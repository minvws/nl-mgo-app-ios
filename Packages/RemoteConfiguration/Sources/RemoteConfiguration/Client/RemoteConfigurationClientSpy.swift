/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

public class RemoteConfigurationClientSpy: RemoteConfigurationClientProtocol {

	public required init(serverUrl: Foundation.URL) { /* Public initializer needed for public access */ }

	public var invokedFetchRemoteConfig = false
	public var invokedFetchRemoteConfigCount = 0
	public var stubbedRemoteConfiguration: RemoteConfig!
	public var stubbedError: Error?
	
	private let queue = DispatchQueue(label: "com.RemoteConfigurationClientSpy.serialqueue.\(UUID().uuidString)")
	
	public func fetchRemoteConfig() async throws -> RemoteConfig {
		queue.sync {
			invokedFetchRemoteConfig = true
			invokedFetchRemoteConfigCount += 1
		}
		
		if let error = stubbedError {
			throw error
		}
		return stubbedRemoteConfiguration
	}
}
