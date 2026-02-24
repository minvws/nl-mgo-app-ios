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

		var database: DatabaseQueue?
		private let clock: any MeasurableClock

		init(clock: (any MeasurableClock)? = nil) {
			self.clock = clock ?? makeMeasurableClock()
		}

		/// Opens or creates the on-disk SQLite database, populates it from
		/// the bundled JSON, and builds an FTS5 search index.
		///
		/// - Returns: The number of organizations inserted.
		/// - Throws: Errors if JSON resource is missing, decoding fails, or
		///   database setup fails.
		func prepare() async throws -> Int {
			let dbQueue = try DatabaseSetup.openDatabase()

			let schemaStart = clock.now()
			try await DatabaseMigrations.clearSchema(in: dbQueue)
			try await DatabaseMigrations.createSchema(in: dbQueue)
			logDebug("OrganizationSearchClient schema: \(clock.elapsed(since: schemaStart))")

			let loadStart = clock.now()
			let organizations = try DatabasePopulator.loadOrganizations()
			logDebug("OrganizationSearchClient JSON load: \(clock.elapsed(since: loadStart))")

			let insertStart = clock.now()
			try await DatabasePopulator.insert(organizations, into: dbQueue)
			logDebug("OrganizationSearchClient insert: \(clock.elapsed(since: insertStart))")

			self.database = dbQueue
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
		return nil
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
