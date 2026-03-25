/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import OrganizationSearch
import FileStorage
import Foundation
import GRDB
import Testing

@Suite(.serialized)
class OrganizationDatasetDownloaderTests {

	let apiClient = LocalizationAPIClientSpy()
	let fileStorage = FileStorageSpy()
	let sut: OrganizationDatasetDownloader
	let dbPool: DatabasePool
	let dbURL: URL

	init() async throws {
		sut = OrganizationDatasetDownloader(apiClient: apiClient, fileStorage: fileStorage)
		dbURL = FileManager.default.temporaryDirectory
			.appendingPathComponent(UUID().uuidString + ".sqlite")
		dbPool = try DatabasePool(path: dbURL.path)
		try await DatabaseMigrations.ensureMetadataTable(in: dbPool)
	}

	deinit {
		try? FileManager.default.removeItem(at: dbURL)
		try? FileManager.default.removeItem(atPath: dbURL.path + "-wal")
		try? FileManager.default.removeItem(atPath: dbURL.path + "-shm")
	}

	// MARK: - fetchOrganizationsData

	@Test("fetchOrganizationsData 200 stores file and ETag, returns data")
	func fetchOrganizationsData_200_storesFileAndETag_returnsData() async throws {

		// Given
		let jsonData = Data(#"[{"id":"org-1"}]"#.utf8)
		apiClient.stubbedFetchResult = (200, "\"etag-1\"", jsonData)

		// When
		let result = try await sut.fetchOrganizationsData(db: dbPool)

		// Then
		#expect(result == jsonData)
		#expect(fileStorage.invokedStore)
		#expect(fileStorage.invokedStoreParameters?.fileName == "organizations.json")
		let storedETag = try await DatabaseMigrations.readETag(
			key: DatabaseMigrations.organizationsETagKey,
			in: dbPool
		)
		#expect(storedETag == "\"etag-1\"")
	}

	@Test("fetchOrganizationsData 200 with missing body throws dataUnavailable")
	func fetchOrganizationsData_200_missingBody_throwsDataUnavailable() async throws {

		// Given
		apiClient.stubbedFetchResult = (200, "\"etag-1\"", nil)

		// When / Then
		await #expect(throws: OrganizationSearchError.dataUnavailable) {
			_ = try await sut.fetchOrganizationsData(db: dbPool)
		}
	}

	@Test("fetchOrganizationsData 304 returns nil without reading from cache")
	func fetchOrganizationsData_304_returnsNil() async throws {

		// Given
		apiClient.stubbedFetchResult = (304, nil, nil)

		// When
		let result = try await sut.fetchOrganizationsData(db: dbPool)

		// Then — nil means "not modified, database already current"
		#expect(result == nil)
		#expect(!fileStorage.invokedRead)
	}

	@Test("fetchOrganizationsData network error with cache returns cached data")
	func fetchOrganizationsData_networkError_withCache_returnsCachedData() async throws {

		// Given
		let cachedData = Data(#"[{"id":"cached-org"}]"#.utf8)
		apiClient.stubbedFetchError = URLError(.notConnectedToInternet)
		fileStorage.stubbedReadResult = cachedData

		// When
		let result = try await sut.fetchOrganizationsData(db: dbPool)

		// Then
		#expect(result == cachedData)
		#expect(fileStorage.invokedRead)
	}

	@Test("fetchOrganizationsData network error without cache throws dataUnavailable")
	func fetchOrganizationsData_networkError_withoutCache_throwsDataUnavailable() async throws {

		// Given
		apiClient.stubbedFetchError = URLError(.notConnectedToInternet)
		fileStorage.stubbedReadResult = nil

		// When / Then
		await #expect(throws: OrganizationSearchError.dataUnavailable) {
			_ = try await sut.fetchOrganizationsData(db: dbPool)
		}
	}

	@Test("fetchOrganizationsData undocumented status with cache returns cached data")
	func fetchOrganizationsData_undocumentedStatus_withCache_returnsCachedData() async throws {

		// Given
		let cachedData = Data(#"[{"id":"cached-org"}]"#.utf8)
		apiClient.stubbedFetchResult = (500, nil, nil)
		fileStorage.stubbedReadResult = cachedData

		// When
		let result = try await sut.fetchOrganizationsData(db: dbPool)

		// Then
		#expect(result == cachedData)
	}

	@Test("fetchOrganizationsData undocumented status without cache throws dataUnavailable")
	func fetchOrganizationsData_undocumentedStatus_withoutCache_throwsDataUnavailable() async throws {

		// Given
		apiClient.stubbedFetchResult = (500, nil, nil)
		fileStorage.stubbedReadResult = nil

		// When / Then
		await #expect(throws: OrganizationSearchError.dataUnavailable) {
			_ = try await sut.fetchOrganizationsData(db: dbPool)
		}
	}

	// MARK: - fetchEndpointsData

	@Test("fetchEndpointsData 200 stores file and ETag, returns data")
	func fetchEndpointsData_200_storesFileAndETag_returnsData() async throws {

		// Given
		let jsonData = Data("{}".utf8)
		apiClient.stubbedFetchResult = (200, "\"ep-etag-1\"", jsonData)

		// When
		let result = try await sut.fetchEndpointsData(db: dbPool)

		// Then
		#expect(result == jsonData)
		#expect(fileStorage.invokedStore)
		#expect(fileStorage.invokedStoreParameters?.fileName == "endpoints.json")
		let storedETag = try await DatabaseMigrations.readETag(
			key: DatabaseMigrations.endpointsETagKey,
			in: dbPool
		)
		#expect(storedETag == "\"ep-etag-1\"")
	}

	@Test("fetchEndpointsData 304 returns nil without reading from cache")
	func fetchEndpointsData_304_returnsNil() async throws {

		// Given
		apiClient.stubbedFetchResult = (304, nil, nil)

		// When
		let result = try await sut.fetchEndpointsData(db: dbPool)

		// Then
		#expect(result == nil)
		#expect(!fileStorage.invokedRead)
	}

	@Test("fetchEndpointsData network error with cache returns cached data")
	func fetchEndpointsData_networkError_withCache_returnsCachedData() async throws {

		// Given
		let cachedData = Data("{}".utf8)
		apiClient.stubbedFetchError = URLError(.notConnectedToInternet)
		fileStorage.stubbedReadResult = cachedData

		// When
		let result = try await sut.fetchEndpointsData(db: dbPool)

		// Then
		#expect(result == cachedData)
	}

	@Test("fetchEndpointsData 200 with missing body throws dataUnavailable")
	func fetchEndpointsData_200_missingBody_throwsDataUnavailable() async throws {

		// Given
		apiClient.stubbedFetchResult = (200, "\"ep-etag\"", nil)

		// When / Then
		await #expect(throws: OrganizationSearchError.dataUnavailable) {
			_ = try await sut.fetchEndpointsData(db: dbPool)
		}
	}

	// MARK: - cleanUp

	@Test("cleanUp removes both cached files from storage")
	func cleanUp_removesBothFiles() {

		// When
		sut.cleanUp()

		// Then
		let removedFiles = fileStorage.invokedRemoveParametersList.map(\.fileName)
		#expect(removedFiles.contains("organizations.json"))
		#expect(removedFiles.contains("endpoints.json"))
		#expect(fileStorage.invokedRemoveCount == 2)
	}
}
