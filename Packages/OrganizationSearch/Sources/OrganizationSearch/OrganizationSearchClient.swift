/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGODebug

/// GRDB-backed implementation of healthcare organization search.
///
/// Loads organization data from a bundled JSON file into an on-disk SQLite
/// database with FTS5 full-text search on `prepare()`.
///
/// All database operations are delegated to `DatabaseActor`, keeping
/// database I/O off the main thread and ensuring thread-safe access to the
/// shared `DatabasePool`.
public class OrganizationSearchClient: OrganizationSearchClientProtocol {

	private let dbActor = DatabaseActor()

	required public init() {}

	/// Prepares the search database on a background actor.
	///
	/// Opens the on-disk SQLite database, rebuilds the schema, and populates
	/// it from the bundled JSON. The database becomes available for searches
	/// as soon as the schema is ready — concurrent `searchHealthcareOrganizations`
	/// calls may return empty results while the background insert is still running.
	///
	/// - Throws: `OrganizationSearchClientError.resourceNotFound` if the bundled
	///   JSON is missing; GRDB errors if the database cannot be opened or written.
	public func prepare() async throws {
		let count = try await dbActor.prepare()
		logDebug("OrganizationSearchClient: prepared database with \(count) organizations")
	}

	/// Searches for healthcare organizations matching the given term.
	///
	/// Delegates to `DatabaseActor.search(_:)`, which executes a concurrent
	/// FTS5 read against the SQLite database on a background executor.
	///
	/// - Parameter searchTerm: The raw user-entered query string.
	/// - Returns: Matching organizations ordered by relevance, or `nil` if
	///   `searchTerm` is blank.
	/// - Throws: `OrganizationSearchClientError.notPrepared` if `prepare()` has
	///   not yet been called; GRDB or decoding errors on query failure.
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
