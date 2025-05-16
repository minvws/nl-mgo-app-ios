/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import Observatory

public class RemoteConfigurationRepositorySpy: RemoteConfigurationRepositoryProtocol {
	
	public init() { /* Public initializer needed for public access */ }
	
	public var invokedStoredConfigurationGetter = false
	public var invokedStoredConfigurationGetterCount = 0
	public var stubbedStoredConfiguration: RemoteConfig!
	
	public var storedConfiguration: RemoteConfig {
		invokedStoredConfigurationGetter = true
		invokedStoredConfigurationGetterCount += 1
		return stubbedStoredConfiguration
	}
	
	public var invokedObservatoryGetter = false
	public var invokedObservatoryGetterCount = 0
	public var stubbedObservatory: Observatory<RemoteConfig>!
	
	public var observatory: Observatory<RemoteConfig> {
		invokedObservatoryGetter = true
		invokedObservatoryGetterCount += 1
		return stubbedObservatory
	}
	
	public var invokedWipePersistedData = false
	public var invokedWipePersistedDataCount = 0
	
	public var invokedFetchAndUpdateObservers = false
	public var invokedFetchAndUpdateObserversCount = 0
	
	public func fetchAndUpdateObservers() {
		invokedFetchAndUpdateObservers = true
		invokedFetchAndUpdateObserversCount += 1
	}

	public func wipePersistedData() {
		invokedWipePersistedData = true
		invokedWipePersistedDataCount += 1
	}
}
