/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GRDB
import MGODebug

/// GRDB-backed implementation of healthcare organization search.
///
/// Loads organization data from a bundled JSON file into an on-disk SQLite
/// database with FTS5 full-text search on `prepare()`.
///
/// All database operations are delegated to `DatabaseActor`, a private actor
/// that serialises access to the `DatabaseQueue` on a background executor,
/// keeping database work off the main thread.
public class OrganizationSearchClient: OrganizationSearchClientProtocol {

	/// A private actor that owns the `DatabaseQueue` and serialises all
	/// database access on a background executor.
	private actor DatabaseActor {

		var database: DatabasePool?
		private let clock: any MeasurableClock

		init(clock: (any MeasurableClock)? = nil) {
			self.clock = clock ?? makeMeasurableClock()
		}

		/// Searches for organizations matching the given term using FTS5.
		///
		/// - Parameter searchTerm: The query string.
		/// - Returns: A `SearchResults` value, or `nil` if the term is empty.
		/// - Throws: `OrganizationSearchClientError.notPrepared` if `prepare()` has not been called.
		func search(_ searchTerm: String) async throws -> SearchResults? {
			guard let dbQueue = database else {
				throw OrganizationSearchClientError.notPrepared
			}

			let searchStart = clock.now()
			let result = try await dbQueue.read { db in
				let (rows, totalCount) = try DatabaseSearchQuery.fetch(matching: searchTerm, in: db)
				guard !rows.isEmpty else { return SearchResults?.none }
				return try DatabaseSearchResultFactory.makeSearchResults(from: rows, totalCount: totalCount)
			}
			logDebug("OrganizationSearchClient search(\"\(searchTerm)\"): \(clock.elapsed(since: searchStart))")
			return result
		}

		/// Opens or creates the on-disk SQLite database, populates it from
		/// the bundled JSON, and builds an FTS5 search index.
		///
		/// - Returns: The number of organizations inserted.
		/// - Throws: Errors if JSON resource is missing, decoding fails, or
		///   database setup fails.
		func prepare() async throws -> Int {
			let dbPool = try DatabaseSetup.openDatabase()

			let schemaStart = clock.now()
			try await DatabaseMigrations.clearSchema(in: dbPool)
			try await DatabaseMigrations.createSchema(in: dbPool)
			logDebug("OrganizationSearchClient schema: \(clock.elapsed(since: schemaStart))")

			// Make the pool available for searches before inserting rows.
			// DatabasePool allows concurrent reads during the write transaction.
			self.database = dbPool

			let loadStart = clock.now()
			let organizations = try DatabasePopulator.loadOrganizations()
			logDebug("OrganizationSearchClient JSON load: \(clock.elapsed(since: loadStart))")

			let insertStart = clock.now()
			try await DatabasePopulator.insert(organizations, into: dbPool)
			logDebug("OrganizationSearchClient insert: \(clock.elapsed(since: insertStart))")

			return organizations.count
		}
	}

	private let dbActor = DatabaseActor()

	required public init() {}

	/// Prepares the search database asynchronously on a background actor.
	///
	/// - Throws: Errors if the JSON resource is missing, decoding fails, or
	///   database setup fails.
	public func prepare() async throws {
		let count = try await dbActor.prepare()
		logDebug("OrganizationSearchClient: prepared database with \(count) organizations")
	}

	public func searchHealthcareOrganizations(_ searchTerm: String) async throws -> SearchResults? {
		return try await dbActor.search(searchTerm)
	}

	public func getVersion(fileName: String = "version") throws -> Version {
		throw Version.Error.noResource
	}
}

// MARK: - Errors

enum OrganizationSearchClientError: Error {
	case resourceNotFound
	case notPrepared
}
