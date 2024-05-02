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

	public var invokedRead = false
	public var invokedReadCount = 0
	public var stubbedReadError: Error?
	public var stubbedReadResult: [HealthcareProvider]! = []

	public func read() throws -> [HealthcareProvider] {
		invokedRead = true
		invokedReadCount += 1
		if let error = stubbedReadError {
			throw error
		}
		return stubbedReadResult
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

	public var invokedWipe = false
	public var invokedWipeCount = 0

	public func wipe() {
		invokedWipe = true
		invokedWipeCount += 1
	}
}
