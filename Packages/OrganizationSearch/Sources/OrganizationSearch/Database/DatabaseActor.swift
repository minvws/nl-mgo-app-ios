/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

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
/// Call `prepare()` once to open the database, build the schema, and populate
/// it from the bundled JSON. The pool is made available for concurrent reads as
/// soon as the schema is ready, so `search(_:)` can be called while the
/// background insert is still running.
actor DatabaseActor {

	/// The live database pool, `nil` until `prepare()` has completed schema setup.
	var database: DatabasePool?

	private let clock: any MeasurableClock

	init(clock: (any MeasurableClock)? = nil) {
		self.clock = clock ?? makeMeasurableClock()
	}

	// MARK: - Search

	/// Searches for organizations matching the given term using FTS5.
	///
	/// Uses a prefix-wildcard query so that partial words match
	/// (e.g. `"tan"` matches `"tandarts"`). Each word in `searchTerm` is
	/// suffixed with `*` before being passed to the FTS5 engine.
	///
	/// The search runs inside a `DatabasePool.read` closure, which is a
	/// concurrent, non-blocking read that can proceed in parallel with the
	/// background write transaction that populates the database.
	///
	/// - Parameter searchTerm: The raw user-entered query string.
	/// - Returns: A `SearchResults` value containing all matching hits ordered
	///   by FTS5 relevance, or `nil` when `searchTerm` is blank.
	/// - Throws: `OrganizationSearchClientError.notPrepared` if `prepare()` has
	///   not yet been called. GRDB or decoding errors if the query or row
	///   decoding fails.
	func search(_ searchTerm: String) async throws -> SearchResults? {
		guard let dbPool = database else {
			throw OrganizationSearchClientError.notPrepared
		}

		let searchStart = clock.now()
		let result = try await dbPool.read { db in
			let rows = try DatabaseSearchQuery.fetch(matching: searchTerm, in: db)
			guard !rows.isEmpty else { return SearchResults?.none }
			return try DatabaseSearchResultFactory.makeSearchResults(from: rows)
		}
		logDebug("DatabaseActor search(\"\(searchTerm)\"): \(clock.elapsed(since: searchStart))")
		return result
	}

	// MARK: - Prepare

	/// Opens (or recreates) the on-disk SQLite database, builds the schema,
	/// and populates it from the bundled JSON resource.
	///
	/// The pool is assigned to `database` immediately after the schema is
	/// created — before the data insert starts — so that concurrent `search`
	/// calls can already execute (returning empty results) while the
	/// background populate transaction is in progress.
	///
	/// Timing for each phase (schema, JSON load, insert) is written to the
	/// debug log via `logDebug`.
	///
	/// - Returns: The number of organizations inserted.
	/// - Throws: `OrganizationSearchClientError.resourceNotFound` if the
	///   bundled JSON is missing; GRDB errors if the database cannot be opened
	///   or written to; decoding errors if the JSON is malformed.
	func prepare() async throws -> Int {
		let dbPool = try DatabaseSetup.openDatabase()

		let schemaStart = clock.now()
		try await DatabaseMigrations.clearSchema(in: dbPool)
		try await DatabaseMigrations.createSchema(in: dbPool)
		logDebug("DatabaseActor schema: \(clock.elapsed(since: schemaStart))")

		// Make the pool available for concurrent reads before inserting rows.
		// DatabasePool uses WAL mode, so reads and writes can run in parallel.
		self.database = dbPool

		let loadStart = clock.now()
		let organizations = try DatabasePopulator.loadOrganizations()
		logDebug("DatabaseActor JSON load: \(clock.elapsed(since: loadStart))")

		let insertStart = clock.now()
		try await DatabasePopulator.insert(organizations, into: dbPool)
		logDebug("DatabaseActor insert: \(clock.elapsed(since: insertStart))")

		return organizations.count
	}
}
