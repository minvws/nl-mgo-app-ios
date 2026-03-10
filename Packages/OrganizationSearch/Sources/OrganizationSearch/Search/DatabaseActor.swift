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
/// populate it from the chosen bundled JSON. The pool is made available for
/// concurrent reads as soon as the schema is ready, so `search(_:)` can be
/// called while the background insert is still running.
actor DatabaseActor {

	/// The live database pool, `nil` until `prepare(dataset:)` has completed schema setup.
	var database: DatabasePool?

	private let clock: any MeasurableClock

	init(clock: (any MeasurableClock)? = nil) {
		self.clock = clock ?? makeMeasurableClock()
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
			return try DatabaseSearchResultFactory.makeSearchResults(from: rows)
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

	/// Opens the on-disk SQLite database and populates it from the bundled JSON
	/// resource, **unless the stored hash shows the data is already current**.
	///
	/// The effective hash is `SHA-256(json) + ":" + schemaVersion`, so both a
	/// JSON change and a schema/normalization change trigger a full rebuild.
	///
	/// The pool is exposed for concurrent reads before the insert phase begins,
	/// so `search(_:)` calls during population return partial results rather
	/// than blocking.
	///
	/// - Parameter dataset: The organization dataset to load.
	/// - Returns: The number of organizations inserted, or `0` when the database
	///   was already up to date and population was skipped.
	/// - Throws: `OrganizationSearchClientError.resourceNotFound` if the bundled
	///   JSON is missing; GRDB errors if the database cannot be opened or written
	///   to; decoding errors if the JSON is malformed.
	func prepare(dataset: OrganizationDataset) async throws -> Int {
		let dbPool = try DatabaseSetup.openDatabase(for: dataset)
		try await DatabaseMigrations.ensureMetadataTable(in: dbPool)

		let jsonData = try DatabasePopulator.loadJSONData(for: dataset)
		let currentHash = effectiveHash(of: jsonData)

		guard try await requiresRepopulation(hash: currentHash, in: dbPool) else {
			self.database = dbPool
			return 0
		}

		return try await repopulate(with: jsonData, hash: currentHash, in: dbPool)
	}

	// MARK: - Private

	/// Returns the effective hash for `jsonData`: SHA-256 of the raw bytes suffixed
	/// with the current `schemaVersion` so that schema or normalization changes
	/// also force a rebuild.
	private func effectiveHash(of jsonData: Data) -> String {
		let start = clock.now()
		let hash = DatabasePopulator.computeHash(of: jsonData) + ":" + DatabaseMigrations.schemaVersion
		logDebug("DatabaseActor hash: \(clock.elapsed(since: start))")
		return hash
	}

	/// Returns `true` when the stored hash differs from `hash`, meaning the database
	/// needs to be rebuilt. Logs a skip message and returns `false` when up to date.
	private func requiresRepopulation(hash: String, in dbPool: DatabasePool) async throws -> Bool {
		let storedHash = try await DatabaseMigrations.readHash(in: dbPool)
		if storedHash == hash {
			logDebug("DatabaseActor: dataset up to date, skipping populate")
			return false
		}
		return true
	}

	/// Clears and recreates the schema, decodes and inserts all organizations,
	/// then stores the new hash. Makes the pool available for reads before
	/// inserting so that concurrent searches can proceed during population.
	///
	/// - Returns: The number of organizations inserted.
	private func repopulate(with jsonData: Data, hash: String, in dbPool: DatabasePool) async throws -> Int {
		let schemaStart = clock.now()
		try await DatabaseMigrations.clearSchema(in: dbPool)
		try await DatabaseMigrations.createSchema(in: dbPool)
		logDebug("DatabaseActor schema: \(clock.elapsed(since: schemaStart))")

		// Expose the pool for reads before inserting — WAL mode allows concurrent reads/writes.
		self.database = dbPool

		let decodeStart = clock.now()
		let organizations = try DatabasePopulator.decode(jsonData)
		logDebug("DatabaseActor JSON decode: \(clock.elapsed(since: decodeStart))")

		let insertStart = clock.now()
		try await DatabasePopulator.insert(organizations, into: dbPool)
		logDebug("DatabaseActor insert: \(clock.elapsed(since: insertStart)) for \(organizations.count) organizations")

		try await DatabaseMigrations.writeHash(hash, in: dbPool)
		return organizations.count
	}
}
