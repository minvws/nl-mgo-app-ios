/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import RemoteConfiguration
import MGOTest

final class RemoteConfigurationRepositoryTests: XCTestCase {
	
	private var storageSpy: FileStorageSpy!
	private var clientSpy: RemoteConfigurationClientSpy!
	private var sut: RemoteConfigurationRepository!
	
	override func setUpWithError() throws {
		
		try super.setUpWithError()
		let serverUrl = try XCTUnwrap(URL(string: "https://example.com"))
		storageSpy = FileStorageSpy()
		clientSpy = RemoteConfigurationClientSpy(serverUrl: serverUrl)
		sut = RemoteConfigurationRepository(storage: storageSpy, apiClient: clientSpy)
	}
	
	override func tearDown() {

		super.tearDown()
		sut.wipePersistedData()
	}
	
	func test_init() {
		
		// Given
		
		// When
		let config = sut.storedConfiguration
		
		// Then
		expect(config) == RemoteConfig.fallback
	}

	func test_fetchFromAPI() {
		
		// Given
		clientSpy.stubbedRemoteConfiguration = RemoteConfig(iosMinimumVersion: "fetchFromApi")
		
		// When
		sut.fetchAndUpdateObservers()
		
		// Then
		expect(self.sut.storedConfiguration).toEventually(equal(clientSpy.stubbedRemoteConfiguration))
	}
	
	func test_fetchFromStorage() throws {
		
		// Given
		let error = NSError(domain: "RemoteConfigurationRepositoryTests", code: 404)
		clientSpy.stubbedError = error // Error from API
		let config = RemoteConfig(iosMinimumVersion: "fetchFromStorage")
		let encoded = try JSONEncoder().encode(config)
		storageSpy.stubbedReadResult = encoded // Config from storage
		
		// When
		sut.fetchAndUpdateObservers()
		
		// Then
		expect(self.sut.storedConfiguration).toEventually(equal(config))
	}
	
	func test_fetchFromStorage_noClient() throws {
		
		// Given
		let config = RemoteConfig(iosMinimumVersion: "fetchFromStorage")
		let encoded = try JSONEncoder().encode(config)
		storageSpy.stubbedReadResult = encoded // Config from storage
		sut = RemoteConfigurationRepository(storage: storageSpy, apiClient: nil)
		
		// When
		sut.fetchAndUpdateObservers()
		
		// Then
		expect(self.sut.storedConfiguration).toEventually(equal(config))
	}
	
	func test_fetchFromFallBack() throws {
		
		// Given
		let error = NSError(domain: "RemoteConfigurationRepositoryTests", code: 404)
		clientSpy.stubbedError = error // Error from API
		storageSpy.stubbedReadResult = Data() // No config from storage
		
		// When
		sut.fetchAndUpdateObservers()
		
		// Then
		expect(self.sut.storedConfiguration).toEventually(equal(RemoteConfig.fallback))
	}
}
