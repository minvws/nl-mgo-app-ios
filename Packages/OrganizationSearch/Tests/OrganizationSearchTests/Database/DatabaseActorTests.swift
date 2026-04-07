/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import OrganizationSearch
import FileStorage
import Testing
import Foundation

@Suite(.serialized)
class DatabaseActorTests {

	let apiClient = LocalizationAPIClientSpy()
	let fileStorage = FileStorageSpy()
	let sut: DatabaseActor

	init() throws {
		try DatabaseActorTests.deleteDatabase(for: .remote)
		let downloader = OrganizationDatasetDownloader(
			apiClient: apiClient,
			fileStorage: fileStorage
		)
		sut = DatabaseActor(downloader: downloader)
	}

	// MARK: - prepareFromAPI — both 304

	@Test("prepareFromAPI both 304 after prior 200 sets database and returns 0")
	func prepareFromAPI_bothNotModified_setsDatabase_returnsZero() async throws {

		// Given — first prepare populates the database (200 for both)
		let orgData = Data(#"[{"id":"org-1","name":"Test Org"}]"#.utf8)
		let epData = Data("{}".utf8)
		apiClient.stubbedFetchResults[.organizations] = (200, "\"org-etag-v1\"", orgData)
		apiClient.stubbedFetchResults[.endpoints] = (200, "\"ep-etag-v1\"", epData)
		_ = try await sut.prepare(dataset: .remote)

		// Given — second prepare: server returns 304 (data unchanged)
		apiClient.stubbedFetchResults = [:]
		apiClient.stubbedFetchResult = (statusCode: 304, eTag: nil, data: nil)

		// When
		let count = try await sut.prepare(dataset: .remote)

		// Then
		#expect(count == 0)
		// Database is accessible — search does not throw notPrepared
		let result = try await sut.search("anything")
		#expect(result.hits.isEmpty)
	}

	// MARK: - prepareFromAPI — mixed 304/200

	@Test("prepareFromAPI mixed 304/200 keeps existing database and returns 0")
	func prepareFromAPI_mixed_keepsExistingDatabase_returnsZero() async throws {

		// Given — first prepare populates the database (200 for both)
		let orgData = Data(#"[{"id":"org-1","name":"Test Org"}]"#.utf8)
		let epData = Data("{}".utf8)
		apiClient.stubbedFetchResults[.organizations] = (200, "\"org-etag-v1\"", orgData)
		apiClient.stubbedFetchResults[.endpoints] = (200, "\"ep-etag-v1\"", epData)
		_ = try await sut.prepare(dataset: .remote)

		// Given — second prepare: organizations changed (200), endpoints unchanged (304)
		let newOrgData = Data(#"[{"id":"org-2","name":"Other Org"}]"#.utf8)
		apiClient.stubbedFetchResults[.organizations] = (200, "\"org-etag-v2\"", newOrgData)
		apiClient.stubbedFetchResults[.endpoints] = (statusCode: 304, eTag: nil, data: nil)

		// When
		let count = try await sut.prepare(dataset: .remote)

		// Then — mixed path: kept existing DB, no repopulation
		#expect(count == 0)
		let result = try await sut.search("anything")
		#expect(result.hits.isEmpty)
	}

	// MARK: - prepareFromAPI — both 200

	@Test("prepareFromAPI both 200 repopulates database and calls cleanUp")
	func prepareFromAPI_both200_repopulatesAndCleanUp() async throws {

		// Given — both return new data
		let orgData = Data(#"[{"id":"org-1","name":"Test Org"}]"#.utf8)
		let epData = Data("{}".utf8)
		apiClient.stubbedFetchResults[.organizations] = (200, "\"org-etag-v1\"", orgData)
		apiClient.stubbedFetchResults[.endpoints] = (200, "\"ep-etag-v1\"", epData)

		// When
		let count = try await sut.prepare(dataset: .remote)

		// Then
		#expect(count == 1) // one organization inserted
		// cleanUp was called — both files removed from storage
		let removedFiles = fileStorage.invokedRemoveParametersList.map(\.fileName)
		#expect(removedFiles.contains("organizations.json"))
		#expect(removedFiles.contains("endpoints.json"))
	}

	// MARK: - prepareFromBundle

	@Test("prepareFromBundle second prepare with unchanged data skips repopulation")
	func prepareFromBundle_sameHash_skipsRepopulation() async throws {

		// Given — use a fresh bundle-backed dataset
		try DatabaseActorTests.deleteDatabase(for: .test)
		let bundleActor = DatabaseActor()

		// When
		let firstCount = try await bundleActor.prepare(dataset: .test)
		let secondCount = try await bundleActor.prepare(dataset: .test)

		// Then
		#expect(firstCount > 0)
		#expect(secondCount == 0)
		await bundleActor.teardown()
	}

	@Test("prepareFromBundle search works after prepare")
	func prepareFromBundle_searchWorks_afterPrepare() async throws {

		// Given
		let bundleActor = DatabaseActor()
		_ = try await bundleActor.prepare(dataset: .test)

		// When
		let result = try await bundleActor.search("Testtest")

		// Then
		#expect(!result.hits.isEmpty)
		await bundleActor.teardown()
	}

	// MARK: - teardown

	@Test("teardown makes subsequent search throw notPrepared")
	func teardown_nilsDatabase() async throws {

		// Given — prepare first so database is set
		apiClient.stubbedFetchResult = (304, nil, nil)
		_ = try await sut.prepare(dataset: .remote)

		// When
		await sut.teardown()

		// Then
		await #expect(throws: OrganizationSearchError.notPrepared) {
			_ = try await sut.search("anything")
		}
	}

	// MARK: - Helpers

	static func deleteDatabase(for dataset: OrganizationDataset) throws {
		let appSupportURL = try FileManager.default.url(
			for: .applicationSupportDirectory,
			in: .userDomainMask,
			appropriateFor: nil,
			create: false
		)
		let dbURL = appSupportURL.appendingPathComponent("\(dataset.resourceName).sqlite")
		try? FileManager.default.removeItem(at: dbURL)
		try? FileManager.default.removeItem(atPath: dbURL.path + "-wal")
		try? FileManager.default.removeItem(atPath: dbURL.path + "-shm")
	}
}
