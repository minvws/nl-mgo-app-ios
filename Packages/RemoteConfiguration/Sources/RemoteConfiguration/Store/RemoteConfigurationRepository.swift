/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import MGODebug
import Observatory
import FileStorage

public protocol RemoteConfigurationRepositoryProtocol {
	
	/// The remote configuration
	var storedConfiguration: RemoteConfig { get }
	
	/// Observatory for changes
	var observatory: Observatory<RemoteConfig> { get }
	
	/// Fetch the config and update all observers
	func fetchAndUpdateObservers()

	/// Remove the remote configuration from storage
	func wipePersistedData()
}

public enum RemoteConfigurationError: Error {

	case noApiClient
}

public class RemoteConfigurationRepository: RemoteConfigurationRepositoryProtocol {

	/// The storage provider
	private let storage: FileStorageProtocol
	
	/// The API Client
	private let client: RemoteConfigurationClientProtocol?

	/// The name of the file where we store the remote configuration
	private let fileName: String = {
		
		if NSClassFromString("XCTestCase") == nil {
			return "remoteconfiguration.json"
		} else {
			return "remoteconfiguration_test.json"
		}
	}()
	
	/// Dispatch Queue
	private let queue = DispatchQueue(label: "com.RemoteConfigurationRepository.serialqueue.\(UUID().uuidString)")
	
	/// Observatory for changes
	public let observatory: Observatory<RemoteConfig>
	
	/// Observers for changes
	private let observers: (RemoteConfig) -> Void

	/// The remote configuration
	public var storedConfiguration: RemoteConfig

	/// Initializer
	/// - Parameter storage: storage protocol
	/// - Parameter apiClient: storage protocol
	public init(
		storage: FileStorageProtocol = FileStorage(),
		apiClient: RemoteConfigurationClientProtocol?) {

		self.storage = storage
		self.client = apiClient
		(self.observatory, self.observers) = Observatory<RemoteConfig>.create()
		storedConfiguration = RemoteConfig.fallback
	}
	
	public func fetchAndUpdateObservers() {
		
		_Concurrency.Task {
			let config = await fetchConfig()
			storedConfiguration = config
			try? persistToStorage()
			observers(config)
		}
	}
	
	func fetchConfig() async -> RemoteConfig {
		do {
			// First attempt to fetch from the api
			let config = try await fetchFromApi()
			return config
		} catch {
			logError("RemoteConfigurationRepository: Error fetching config", error)
			// If that fails, fetch from disc.
			do {
				if let config = try readFromStorage() {
					return config
				}
			} catch {
				logError("RemoteConfigurationRepository: Error reading config", error)
			}
		}
	
		logInfo("RemoteConfigurationRepository: Fail back to default config")
		return RemoteConfig.fallback
	}
	
	/// Read the config from the API
	/// - Returns: Remote config from API
	internal func fetchFromApi() async throws -> RemoteConfig {
		
		guard let client else {
			throw RemoteConfigurationError.noApiClient
		}
		
		return try await client.fetchRemoteConfig()
	}
	
	/// Read the config from storage
	/// - Returns: remote config from storage
	///
	internal func readFromStorage() throws -> RemoteConfig? {
		
		if let jsonData = storage.read(fileName: fileName) {
			let config = try JSONDecoder().decode(RemoteConfig.self, from: jsonData)
			return config
		}
		return nil
	}
	
	/// Reset the remote config to default, remove existing cached
	public func wipePersistedData() {
		
		storedConfiguration = RemoteConfig.fallback
		storage.remove(fileName)
	}
	
	/// Persist the remote config to storage
	private func persistToStorage() throws {
		#warning("This is stored in plain text on disk. Before release, this should be changed!")
		try queue.sync {
			let encoded = try JSONEncoder().encode(storedConfiguration)
			try storage.store(encoded, as: fileName)
		}
	}
}
