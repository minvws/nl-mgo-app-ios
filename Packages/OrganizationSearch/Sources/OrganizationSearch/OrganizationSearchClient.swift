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
public class OrganizationSearchClient: OrganizationSearchClientProtocol {

	/// The on-disk GRDB database, populated during `prepare()`.
	private var database: DatabaseQueue?

	required public init() {}

	/// Opens or creates the on-disk SQLite database, populates it from the
	/// bundled JSON, and builds an FTS5 search index.
	///
	/// If the database already exists on disk the JSON import is skipped.
	///
	/// - Throws: Errors if the JSON resource is missing, decoding fails, or
	///   database setup fails.
	public func prepare() async throws {
		let dbQueue = try DatabaseSetup.openDatabase()
		try await DatabaseMigrations.clearSchema(in: dbQueue)
		let organizations = try DatabasePopulator.loadOrganizations()
		try await DatabaseMigrations.createSchema(in: dbQueue)
		try await DatabasePopulator.insert(organizations, into: dbQueue)
		logDebug("OrganizationSearchClient: prepared database with \(organizations.count) organizations")
		self.database = dbQueue
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

