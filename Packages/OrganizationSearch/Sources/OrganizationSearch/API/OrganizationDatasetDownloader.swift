/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import FileStorage
import Foundation
import GRDB
import Localization
import MGODebug

/// Orchestrates download, file-cache and ETag persistence for the organization datasets.
///
/// Each fetch method follows the pattern:
/// 1. Read ETag from the GRDB `metadata` table.
/// 2. Issue a conditional GET via `apiClient`.
/// 3. On 200 – persist body to `FileStorage` and write the new ETag.
/// 4. On 304 – return the previously cached file.
/// 5. On network error – fall back to the cached file; throw `dataUnavailable` if absent.
public struct OrganizationDatasetDownloader: Sendable {

	let apiClient: any LocalizationAPIClientProtocol
	let fileStorage: any FileStorageProtocol

	/// Creates a new downloader.
	/// - Parameters:
	///   - apiClient: The API client used to issue conditional GET requests.
	///   - fileStorage: The file storage used to persist and retrieve cached dataset files.
	public init(
		apiClient: any LocalizationAPIClientProtocol,
		fileStorage: any FileStorageProtocol
	) {
		self.apiClient = apiClient
		self.fileStorage = fileStorage
	}

	// MARK: - Organisations

	/// Downloads or returns the cached organisations JSON.
	/// - Parameter db: The database pool used to read/write the ETag.
	/// - Returns: Raw JSON data, or `nil` if the server returned 304 (database already current).
	func fetchOrganizationsData(db: DatabasePool) async throws -> Data? {

		try await fetchDataset(
			endpoint: .organizations,
			eTagKey: DatabaseMigrations.organizationsETagKey,
			fileName: "organizations.json",
			db: db
		)
	}

	// MARK: - Endpoints

	/// Downloads or returns the cached endpoints JSON.
	/// - Parameter db: The database pool used to read/write the ETag.
	/// - Returns: Raw JSON data, or `nil` if the server returned 304 (database already current).
	func fetchEndpointsData(db: DatabasePool) async throws -> Data? {

		try await fetchDataset(
			endpoint: .endpoints,
			eTagKey: DatabaseMigrations.endpointsETagKey,
			fileName: "endpoints.json",
			db: db
		)
	}

	// MARK: - Cleanup

	/// Removes the cached organizations and endpoints files from storage.
	///
	/// Call this after a successful database repopulation to free up storage space — the
	/// data is now in SQLite and the intermediate JSON files are no longer needed.
	func cleanUp() {
		fileStorage.remove("organizations.json")
		fileStorage.remove("endpoints.json")
	}

	// MARK: - Private

	/// Generic dataset fetcher that handles ETag, conditional GET, caching and fallbacks.
	private func fetchDataset(
		endpoint: LocalizationEndpoint,
		eTagKey: String,
		fileName: String,
		db: DatabasePool
	) async throws -> Data? {

		let eTag = try await DatabaseMigrations.readETag(key: eTagKey, in: db)

		let result: (statusCode: Int, eTag: String?, data: Data?)
		do {
			result = try await apiClient.fetch(endpoint, eTag: eTag)
		} catch {
			logError("OrganizationDatasetDownloader: network error for \(endpoint), falling back to cache: \(error)")
			if let cached = fileStorage.read(fileName: fileName) {
				logInfo("OrganizationDatasetDownloader: served \(fileName) from cache after network error")
				return cached
			}
			throw OrganizationSearchError.dataUnavailable
		}

		switch result.statusCode {
			case 200:
				guard let data = result.data else {
					logError("OrganizationDatasetDownloader: 200 without body for \(fileName)")
					throw OrganizationSearchError.dataUnavailable
				}
				try fileStorage.store(data, as: fileName)
				logDebug("OrganizationDatasetDownloader: updating ETag for \(fileName) to \(result.eTag ?? "nil")")
				try await DatabaseMigrations.writeETag(result.eTag, key: eTagKey, in: db)
				return data

			case 304:
				logInfo("OrganizationDatasetDownloader: \(fileName) not modified — database already current")
				return nil

			default:
				logWarning("OrganizationDatasetDownloader: unexpected status \(result.statusCode) for \(fileName); attempting cache fallback")
				if let cached = fileStorage.read(fileName: fileName) {
					logInfo("OrganizationDatasetDownloader: served \(fileName) from cache after unexpected status \(result.statusCode)")
					return cached
				}
				throw OrganizationSearchError.dataUnavailable
		}
	}
}
