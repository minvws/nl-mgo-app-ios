/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

class HealthcareProviderStoreSpy: HealthcareProviderStoreProtocol {

	var invokedProvidersGetter = false
	var invokedProvidersGetterCount = 0
	var stubbedProviders: [HealthcareProvider]! = []

	var providers: [HealthcareProvider] {
		invokedProvidersGetter = true
		invokedProvidersGetterCount += 1
		return stubbedProviders
	}

	var invokedStore = false
	var invokedStoreCount = 0
	var invokedStoreParameters: (provider: HealthcareProvider, Void)?
	var invokedStoreParametersList = [(provider: HealthcareProvider, Void)]()
	var stubbedStoreError: Error?

	func store(_ provider: HealthcareProvider) throws {
		invokedStore = true
		invokedStoreCount += 1
		invokedStoreParameters = (provider, ())
		invokedStoreParametersList.append((provider, ()))
		if let error = stubbedStoreError {
			throw error
		}
	}

	var invokedRead = false
	var invokedReadCount = 0
	var stubbedReadError: Error?
	var stubbedReadResult: [HealthcareProvider]! = []

	func read() throws -> [HealthcareProvider] {
		invokedRead = true
		invokedReadCount += 1
		if let error = stubbedReadError {
			throw error
		}
		return stubbedReadResult
	}

	var invokedRemove = false
	var invokedRemoveCount = 0
	var invokedRemoveParameters: (provider: HealthcareProvider, Void)?
	var invokedRemoveParametersList = [(provider: HealthcareProvider, Void)]()
	var stubbedRemoveError: Error?

	func remove(_ provider: HealthcareProvider) throws {
		invokedRemove = true
		invokedRemoveCount += 1
		invokedRemoveParameters = (provider, ())
		invokedRemoveParametersList.append((provider, ()))
		if let error = stubbedRemoveError {
			throw error
		}
	}

	var invokedWipe = false
	var invokedWipeCount = 0

	func wipe() {
		invokedWipe = true
		invokedWipeCount += 1
	}
}
