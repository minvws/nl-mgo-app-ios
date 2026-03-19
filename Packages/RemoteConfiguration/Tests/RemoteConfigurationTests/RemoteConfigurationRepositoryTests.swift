/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
@testable import RemoteConfiguration
import FileStorage
import Foundation

@MainActor
class RemoteConfigurationRepositoryTests {

	var storageSpy: FileStorageSpy
	var clientSpy: RemoteConfigurationClientSpy
	var sut: RemoteConfigurationRepository

	init() throws {

		let serverUrl = try #require(URL(string: "https://example.com"))
		storageSpy = FileStorageSpy()
		clientSpy = RemoteConfigurationClientSpy(serverUrl: serverUrl)
		sut = RemoteConfigurationRepository(storage: storageSpy, apiClient: clientSpy)
	}

	@Test("init should set the stored configuration to the fallback")
	func test_init() {

		// When
		let config = sut.storedConfiguration

		// Then
		#expect(config == RemoteConfig.fallback)
	}

	@Test("fetchAndUpdateObservers should store the config from the API")
	func test_fetchFromAPI() async {

		// Given
		clientSpy.stubbedRemoteConfiguration = RemoteConfig(iosMinimumVersion: "fetchFromApi")

		// When
		await sut.fetchAndUpdateObservers()

		// Then
		#expect(sut.storedConfiguration == clientSpy.stubbedRemoteConfiguration)
	}

	@Test("fetchAndUpdateObservers should fall back to storage when the API fails")
	func test_fetchFromStorage() async throws {

		// Given
		clientSpy.stubbedError = NSError(domain: "RemoteConfigurationRepositoryTests", code: 404)
		let config = RemoteConfig(iosMinimumVersion: "fetchFromStorage")
		storageSpy.stubbedReadResult = try JSONEncoder().encode(config)

		// When
		await sut.fetchAndUpdateObservers()

		// Then
		#expect(sut.storedConfiguration == config)
	}

	@Test("fetchAndUpdateObservers should fall back to storage when there is no client")
	func test_fetchFromStorage_noClient() async throws {

		// Given
		let config = RemoteConfig(iosMinimumVersion: "fetchFromStorage")
		storageSpy.stubbedReadResult = try JSONEncoder().encode(config)
		sut = RemoteConfigurationRepository(storage: storageSpy, apiClient: nil)

		// When
		await sut.fetchAndUpdateObservers()

		// Then
		#expect(sut.storedConfiguration == config)
	}

	@Test("fetchAndUpdateObservers should fall back to the default config when API and storage both fail")
	func test_fetchFromFallBack() async throws {

		// Given
		clientSpy.stubbedError = NSError(domain: "RemoteConfigurationRepositoryTests", code: 404)
		storageSpy.stubbedReadResult = Data()

		// When
		await sut.fetchAndUpdateObservers()

		// Then
		#expect(sut.storedConfiguration == RemoteConfig.fallback)
	}
}
