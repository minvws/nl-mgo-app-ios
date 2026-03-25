/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import GRDB
import MGODebug

/// Owns the `DatabasePool` and serialises all database access on a background executor.
///
/// `DatabaseActor` is the single gatekeeper for the SQLite database used by
/// `OrganizationSearchClient`. Placing it in a Swift `actor` guarantees:
///
/// - **Thread safety** – the mutable `database` property is never accessed from
///   more than one concurrency domain at a time.
/// - **Background execution** – Swift schedules actor work on a non-main
///   executor, so database I/O never blocks the main thread.
///
/// ## Lifecycle
/// Call `prepare(dataset:)` once to open the database, build the schema, and
/// populate it from the chosen bundled JSON or remote API. The pool is made
/// available for concurrent reads as soon as the schema is ready, so `search(_:)`
/// can be called while the background insert is still running.
actor DatabaseActor {

	/// The live database pool, `nil` until `prepare(dataset:)` has completed schema setup.
	var database: DatabasePool?

	private let clock: any MeasurableClock
	private let downloader: OrganizationDatasetDownloader?

	init(
		clock: (any MeasurableClock)? = nil,
		downloader: OrganizationDatasetDownloader? = nil
	) {
		self.clock = clock ?? makeMeasurableClock()
		self.downloader = downloader
	}

	// MARK: - Search

	/// Searches for organizations matching the given term using FTS5.
	///
	/// Delegates query building to `DatabaseSearchQuery`, which uses a two-pass
	/// strategy: a fast prefix pass followed by an edit-distance-1 fuzzy fallback.
	/// The search runs inside a `DatabasePool.read` closure — a concurrent,
	/// non-blocking read that can proceed in parallel with the background
	/// write transaction that populates the database.
	///
	/// - Parameter searchTerm: The raw user-entered query string.
	/// - Returns: A `SearchResults` value containing all matching hits ordered
	///   by weighted BM25 relevance, or an empty `SearchResults` when `searchTerm`
	///   yields no FTS5 tokens.
	/// - Throws: `OrganizationSearchError.notPrepared` if `prepare()` has
	///   not yet been called; GRDB or decoding errors if the query or row
	///   decoding fails.
	func search(_ searchTerm: String) async throws -> SearchResults {

		guard let dbPool = database else {
			throw OrganizationSearchError.notPrepared
		}

		let searchStart = clock.now()
		let result = try await dbPool.read { db in
			let rows = try DatabaseSearchQuery.fetch(matching: searchTerm, in: db)
			guard !rows.isEmpty else { return SearchResults(count: 0, hits: []) }
			return try DatabaseSearchResultFactory.makeSearchResults(from: rows, in: db)
		}
		logDebug("DatabaseActor search(\"\(searchTerm)\"): \(clock.elapsed(since: searchStart))")
		return result
	}

	// MARK: - Teardown

	/// Closes the database pool and releases all associated resources.
	///
	/// Nils out the `DatabasePool`, which closes the underlying SQLite file
	/// descriptor and frees the WAL journal. After this call `search(_:)` will
	/// throw `OrganizationSearchError.notPrepared` until `prepare(dataset:)` is
	/// called again.
	///
	/// Idempotent: calling it when `database` is already `nil` is a no-op.
	func teardown() {
		database = nil
	}

	// MARK: - Prepare

	/// Opens the on-disk SQLite database and populates it from the bundled JSON or
	/// remote API, **unless the stored content key shows the data is already current**.
	///
	/// For bundle-backed datasets the content key is `SHA-256(org) + ":" +
	/// SHA-256(endpoints) + ":" + schemaVersion`. For API-downloaded datasets it is
	/// `orgETag + ":" + endpointsETag + ":" + schemaVersion`, so a server-side data
	/// change (reflected by a new ETag) triggers a full rebuild without re-hashing
	/// the payload.
	///
	/// The pool is exposed for concurrent reads before the insert phase begins,
	/// so `search(_:)` calls during population return partial results rather
	/// than blocking.
	///
	/// - Parameter dataset: The organization dataset to load.
	/// - Returns: The number of organizations inserted, or `0` when the database
	///   was already up to date and population was skipped.
	/// - Throws: `OrganizationSearchClientError.resourceNotFound` if the bundled
	///   JSON is missing; `OrganizationSearchError.dataUnavailable` if the API
	///   is unreachable and no cached copy exists; GRDB errors if the database
	///   cannot be opened or written to.
	func prepare(dataset: OrganizationDataset) async throws -> Int {
		if dataset.requiresAPIDownload {
			return try await prepareFromAPI(dataset: dataset)
		} else {
			return try await prepareFromBundle(dataset: dataset)
		}
	}

	// MARK: - Private prepare variants

	/// Prepare path for API-downloaded datasets.
	///
	/// The server drives freshness via ETags: 304 means nothing changed, 200 means
	/// repopulate. No local hash check is needed.
	private func prepareFromAPI(dataset: OrganizationDataset) async throws -> Int {

		let dbPool = try DatabaseSetup.openDatabase(for: dataset)
		try await DatabaseMigrations.ensureMetadataTable(in: dbPool)

		let prepareStart = clock.now()
		async let organizationsFetch = DatabasePopulator.loadOrganizationsData(
			for: dataset,
			downloader: downloader,
			db: dbPool
		)
		async let endpointsFetch = DatabasePopulator.loadEndpointsData(
			for: dataset,
			downloader: downloader,
			db: dbPool
		)
		let (organizationsData, endpointsData) = try await (organizationsFetch, endpointsFetch)
		logDebug("DatabaseActor prepareFromAPI fetch: \(clock.elapsed(since: prepareStart))")

		// Both 304 — nothing changed, database is already current.
		if organizationsData == nil && endpointsData == nil {
			self.database = dbPool
			return 0
		}

		// Both 200 — repopulate. Build content key from the ETags the downloader wrote.
		let orgETag = try await DatabaseMigrations.readETag(
			key: DatabaseMigrations.organizationsETagKey,
			in: dbPool
		)
		let epETag = try await DatabaseMigrations.readETag(
			key: DatabaseMigrations.endpointsETagKey,
			in: dbPool
		)
		let contentKey = "\(orgETag ?? ""):\(epETag ?? ""):\(DatabaseMigrations.schemaVersion)"

		guard let orgData = organizationsData, let epData = endpointsData else {
			// Mixed 304/200 — one dataset changed, one didn't. Both datasets are needed to
			// repopulate, but the server publishes them together so this shouldn't occur.
			logWarning("DatabaseActor: partial dataset update (mixed 304/200), keeping existing database")
			self.database = dbPool
			return 0
		}

		let count = try await repopulate(with: orgData, endpointsData: epData, hash: contentKey, in: dbPool)
		downloader?.cleanUp()
		return count
	}

	/// Prepare path for bundle-backed datasets.
	///
	/// Freshness is determined locally by comparing a SHA-256 hash of both JSON files
	/// against the stored content key.
	private func prepareFromBundle(dataset: OrganizationDataset) async throws -> Int {

		let dbPool = try DatabaseSetup.openDatabase(for: dataset)
		try await DatabaseMigrations.ensureMetadataTable(in: dbPool)

		let prepareStart = clock.now()
		async let organizationsFetch = DatabasePopulator.loadOrganizationsData(
			for: dataset,
			downloader: nil,
			db: dbPool
		)
		async let endpointsFetch = DatabasePopulator.loadEndpointsData(
			for: dataset,
			downloader: nil,
			db: dbPool
		)
		let (organizationsData, endpointsData) = try await (organizationsFetch, endpointsFetch)
		logDebug("DatabaseActor prepareFromBundle fetch: \(clock.elapsed(since: prepareStart))")

		guard let organizationsData, let endpointsData else {
			// Bundle resources always return Data or throw — nil is unreachable here.
			logError("DatabaseActor: unexpected nil data from bundle")
			throw OrganizationSearchError.dataUnavailable
		}

		let contentKey = effectiveHash(
			of: organizationsData,
			endpointsData: endpointsData
		)

		guard try await requiresRepopulation(hash: contentKey, in: dbPool) else {
			self.database = dbPool
			return 0
		}

		return try await repopulate(
			with: organizationsData,
			endpointsData: endpointsData,
			hash: contentKey,
			in: dbPool
		)
	}

	// MARK: - Private

	/// Returns the effective hash combining `jsonData` and `endpointsData`, suffixed with
	/// the current `schemaVersion` so that any data or schema change forces a rebuild.
	private func effectiveHash(
		of jsonData: Data,
		endpointsData: Data
	) -> String {

		let start = clock.now()
		let hash = DatabasePopulator.computeHash(of: jsonData)
			+ ":" + DatabasePopulator.computeHash(of: endpointsData)
			+ ":" + DatabaseMigrations.schemaVersion
		logDebug("DatabaseActor hash: \(clock.elapsed(since: start))")
		return hash
	}

	/// Returns `true` when the stored hash differs from `hash`, meaning the database
	/// needs to be rebuilt. Logs a skip message and returns `false` when up to date.
	private func requiresRepopulation(
		hash: String,
		in dbPool: DatabasePool
	) async throws -> Bool {

		let storedHash = try await DatabaseMigrations.readHash(in: dbPool)
		if storedHash == hash {
			logDebug("DatabaseActor: dataset up to date, skipping populate")
			return false
		}
		return true
	}

	/// Clears and recreates the schema, decodes and inserts endpoints and organizations,
	/// then stores the new hash. Makes the pool available for reads before
	/// inserting so that concurrent searches can proceed during population.
	///
	/// Organization data service fields store raw endpoint FK IDs; resolution to
	/// full URLs happens at query time in `DatabaseSearchResultFactory`.
	///
	/// - Returns: The number of organizations inserted.
	private func repopulate(
		with jsonData: Data,
		endpointsData: Data,
		hash: String,
		in dbPool: DatabasePool
	) async throws -> Int {

		let schemaStart = clock.now()
		try await DatabaseMigrations.clearSchema(in: dbPool)
		try await DatabaseMigrations.createSchema(in: dbPool)
		logDebug("DatabaseActor schema: \(clock.elapsed(since: schemaStart))")

		// Expose the pool for reads before inserting — WAL mode allows concurrent reads/writes.
		self.database = dbPool

		let decodeStart = clock.now()
		let endpoints = try DatabasePopulator.decodeEndpoints(endpointsData)
		try await DatabasePopulator.insertEndpoints(endpoints, into: dbPool)
		let organizations = try DatabasePopulator.decode(jsonData)
		logDebug("DatabaseActor JSON decode: \(clock.elapsed(since: decodeStart))")

		let insertStart = clock.now()
		try await DatabasePopulator.insert(organizations, into: dbPool)
		logDebug("DatabaseActor insert: \(clock.elapsed(since: insertStart)) for \(organizations.count) organizations")

		try await DatabaseMigrations.writeHash(hash, in: dbPool)
		return organizations.count
	}
}
