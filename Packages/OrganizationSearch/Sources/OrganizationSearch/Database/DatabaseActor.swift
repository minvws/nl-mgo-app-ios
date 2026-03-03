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
	/// Delegates query building to `DatabaseSearchQuery`, which uses
	/// `FTS5Pattern(matchingAllPrefixesIn:)` so that partial words match
	/// (e.g. `"tan"` matches `"tandarts"`) and punctuation in the input is
	/// handled safely.
	///
	/// The search runs inside a `DatabasePool.read` closure — a concurrent,
	/// non-blocking read that can proceed in parallel with the background
	/// write transaction that populates the database.
	///
	/// - Parameter searchTerm: The raw user-entered query string.
	/// - Returns: A `SearchResults` value containing all matching hits ordered
	///   by FTS5 relevance, or an empty `SearchResults` when `searchTerm` yields
	///   no FTS5 tokens.
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
	
	/// Close the database pool and release all associated resources.
	///
	/// Nils out the `DatabasePool`, which closes the underlying SQLite file
	/// descriptor and frees the WAL journal.  After this call `search(_:)` will
	/// throw `OrganizationSearchError.notPrepared` until `prepare(dataset:)` is
	/// called again.
	///
	/// The method is idempotent: calling it when `database` is already `nil`
	/// is a no-op.
	func teardown() {
		database = nil
	}
	
	// MARK: - Prepare

	/// Opens the on-disk SQLite database and populates it from the bundled JSON
	/// resource, **unless the stored SHA-256 hash shows the data is already current**.
	///
	/// ## Hash-based skip
	/// A `metadata` table persists across schema rebuilds. On each call:
	/// 1. The JSON file is memory-mapped and its SHA-256 digest is computed.
	/// 2. The digest is compared against the value stored in `metadata`.
	/// 3. If they match the database is already up to date — the pool is made
	///    available and the method returns immediately without repopulating.
	/// 4. If they differ (first launch, app update, or data change) the schema is
	///    cleared and rebuilt, data is inserted in chunks, and the new hash is stored.
	///
	/// ## Memory efficiency
	/// The JSON file is memory-mapped rather than copied into RAM. Records are
	/// inserted in chunks of `DatabasePopulator.insertChunkSize` to bound peak
	/// memory usage during the populate phase.
	///
	/// Timing for each phase is written to the debug log via `logDebug`.
	///
	/// - Parameter dataset: The organization dataset to load.
	/// - Returns: The number of organizations inserted, or `0` when the database
	///   was already up to date and populate was skipped.
	/// - Throws: `OrganizationSearchClientError.resourceNotFound` if the bundled
	///   JSON is missing; GRDB errors if the database cannot be opened
	///   or written to; decoding errors if the JSON is malformed.
	func prepare(dataset: OrganizationDataset) async throws -> Int {

		let dbPool = try DatabaseSetup.openDatabase(for: dataset)
		try await DatabaseMigrations.ensureMetadataTable(in: dbPool)

		// Compute the SHA-256 hash of the bundled JSON (mmap'd — no full copy into RAM).
		let hashStart = clock.now()
		let jsonData = try DatabasePopulator.loadJSONData(for: dataset)
		let currentHash = DatabasePopulator.computeHash(of: jsonData)
		logDebug("DatabaseActor hash: \(clock.elapsed(since: hashStart))")

		// Skip repopulation when the database already reflects the current JSON.
		let storedHash = try await DatabaseMigrations.readHash(in: dbPool)
		if storedHash == currentHash {
			logDebug("DatabaseActor: dataset up to date, skipping populate")
			self.database = dbPool
			return 0
		}

		// Hash mismatch — rebuild schema and repopulate.
		let schemaStart = clock.now()
		try await DatabaseMigrations.clearSchema(in: dbPool)
		try await DatabaseMigrations.createSchema(in: dbPool)
		logDebug("DatabaseActor schema: \(clock.elapsed(since: schemaStart))")

		// Make the pool available for concurrent reads before inserting rows.
		// DatabasePool uses WAL mode, so reads and writes can run in parallel.
		self.database = dbPool

		let decodeStart = clock.now()
		let organizations = try DatabasePopulator.decode(jsonData)
		logDebug("DatabaseActor JSON decode: \(clock.elapsed(since: decodeStart))")

		let insertStart = clock.now()
		try await DatabasePopulator.insert(organizations, into: dbPool)
		logDebug("DatabaseActor insert: \(clock.elapsed(since: insertStart)) for \(organizations.count) organizations")

		try await DatabaseMigrations.writeHash(currentHash, in: dbPool)

		return organizations.count
	}
}
