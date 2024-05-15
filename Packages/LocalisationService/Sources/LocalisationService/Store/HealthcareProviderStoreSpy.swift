/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public class HealthcareProviderStoreSpy: HealthcareProviderStoreProtocol {

	public init() {
		// Public initializer needed for public access.
	}
	
	public var invokedProvidersGetter = false
	public var invokedProvidersGetterCount = 0
	public var stubbedProviders: [HealthcareProvider]! = []

	public var providers: [HealthcareProvider] {
		invokedProvidersGetter = true
		invokedProvidersGetterCount += 1
		return stubbedProviders
	}

	public var invokedObservatoryGetter = false
	public var invokedObservatoryGetterCount = 0
	public var stubbedObservatory: Observatory<Bool>!

	public var observatory: Observatory<Bool> {
		invokedObservatoryGetter = true
		invokedObservatoryGetterCount += 1
		return stubbedObservatory
	}

	public var invokedStore = false
	public var invokedStoreCount = 0
	public var invokedStoreParameters: (provider: HealthcareProvider, Void)?
	public var invokedStoreParametersList = [(provider: HealthcareProvider, Void)]()
	public var stubbedStoreError: Error?

	public func store(_ provider: HealthcareProvider) throws {
		invokedStore = true
		invokedStoreCount += 1
		invokedStoreParameters = (provider, ())
		invokedStoreParametersList.append((provider, ()))
		if let error = stubbedStoreError {
			throw error
		}
	}

	public var invokedRemove = false
	public var invokedRemoveCount = 0
	public var invokedRemoveParameters: (provider: HealthcareProvider, Void)?
	public var invokedRemoveParametersList = [(provider: HealthcareProvider, Void)]()
	public var stubbedRemoveError: Error?

	public func remove(_ provider: HealthcareProvider) throws {
		invokedRemove = true
		invokedRemoveCount += 1
		invokedRemoveParameters = (provider, ())
		invokedRemoveParametersList.append((provider, ()))
		if let error = stubbedRemoveError {
			throw error
		}
	}

	public var invokedWipePersistedData = false
	public var invokedWipePersistedDataCount = 0

	public func wipePersistedData() {
		invokedWipePersistedData = true
		invokedWipePersistedDataCount += 1
	}
}
