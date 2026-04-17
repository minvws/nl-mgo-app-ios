/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGODebug

/// GRDB-backed implementation of healthcare organization search.
///
/// Loads organization data from a bundled JSON file or remote API into an
/// on-disk SQLite database with FTS5 full-text search on `prepare()`.
///
/// All database operations are delegated to `DatabaseActor`, keeping
/// database I/O off the main thread and ensuring thread-safe access to the
/// shared `DatabasePool`.
public final class OrganizationSearchClient: OrganizationSearchClientProtocol, Sendable {

	private let dbActor: DatabaseActor

	public init() {
		dbActor = DatabaseActor()
	}

	/// Creates a client that uses a downloader for remote datasets.
	/// - Parameter downloader: The downloader used when `dataset.requiresAPIDownload` is `true`.
	public init(downloader: OrganizationDatasetDownloader) {
		dbActor = DatabaseActor(downloader: downloader)
	}
	
	/// Prepares the search database on a background actor.
	///
	/// Opens the on-disk SQLite database, rebuilds the schema, and populates
	/// it from the bundled JSON for the given `dataset`. The database becomes
	/// available for searches as soon as the schema is ready — concurrent
	/// `searchHealthcareOrganizations` calls may return empty results while the
	/// background insert is still running.
	///
	/// - Parameter dataset: The organization dataset to load. Defaults to `.remote`.
	/// - Throws: `OrganizationSearchClientError.resourceNotFound` if the bundled
	///   JSON is missing; GRDB errors if the database cannot be opened or written.
	public func prepare(dataset: OrganizationDataset = .remote) async throws {

		let count = try await dbActor.prepare(dataset: dataset)
		if count > 0 {
			logDebug("OrganizationSearchClient: prepared database with \(count) organizations")
		} else {
			logDebug("OrganizationSearchClient: database already up to date, skipping prepare")
		}
	}
	
	/// Searches for healthcare organizations matching the given term.
	///
	/// Delegates to `DatabaseActor.search(_:)`, which executes a concurrent
	/// FTS5 read against the SQLite database on a background executor.
	///
	/// - Parameter searchTerm: The raw user-entered query string.
	/// - Returns: Matching organizations ordered by relevance, or an empty `SearchResults` if
	///   `searchTerm` is blank.
	/// - Throws: `OrganizationSearchError.notPrepared` if `prepare()` has
	///   not yet been called; GRDB or decoding errors on query failure.
	public func searchHealthcareOrganizations(
		_ searchTerm: String
	) async throws -> SearchResults {

		return try await dbActor.search(searchTerm)
	}
	
	/// Closes the SQLite database pool and releases all associated resources.
	///
	/// Delegates to `DatabaseActor.teardown()`. After this call, `prepare` must
	/// be called again before searches will succeed.
	public func teardown() async {

		await dbActor.teardown()
	}
}

// MARK: - Errors

/// Errors thrown by `OrganizationSearchClient` and the database layer.
enum OrganizationSearchClientError: Error {
	
	/// The bundled JSON resource file for the requested dataset could not be found.
	case resourceNotFound
}
