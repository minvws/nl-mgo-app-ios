/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public class HealthcareOrganizationRepositorySpy: HealthcareOrganizationRepositoryProtocol {

	public init() {
		// Public initializer needed for public access.
	}
	
	public var invokedOrganizationsGetter = false
	public var invokedOrganizationsGetterCount = 0
	public var stubbedOrganizations: [HealthcareOrganization]! = []

	public var organizations: [HealthcareOrganization] {
		invokedOrganizationsGetter = true
		invokedOrganizationsGetterCount += 1
		return stubbedOrganizations
	}

	public var invokedObservatoryGetter = false
	public var invokedObservatoryGetterCount = 0
	public var stubbedObservatory: Observatory<Bool>!

	public var observatory: Observatory<Bool> {
		invokedObservatoryGetter = true
		invokedObservatoryGetterCount += 1
		return stubbedObservatory
	}
	
	public var invokedRemovalObservatoryGetter = false
	public var invokedRemovalObservatoryGetterCount = 0
	public var stubbedRemovalObservatory: Observatory<HealthcareOrganization>!

	public var removalObservatory: Observatory<HealthcareOrganization> {
		invokedRemovalObservatoryGetter = true
		invokedRemovalObservatoryGetterCount += 1
		return stubbedRemovalObservatory
	}

	public var invokedStore = false
	public var invokedStoreCount = 0
	public var invokedStoreParameters: (organization: HealthcareOrganization, Void)?
	public var invokedStoreParametersList = [(organization: HealthcareOrganization, Void)]()
	public var stubbedStoreError: Error?

	public func store(_ organization: HealthcareOrganization) throws {
		invokedStore = true
		invokedStoreCount += 1
		invokedStoreParameters = (organization, ())
		invokedStoreParametersList.append((organization, ()))
		if let error = stubbedStoreError {
			throw error
		}
	}

	public var invokedRemove = false
	public var invokedRemoveCount = 0
	public var invokedRemoveParameters: (organization: HealthcareOrganization, Void)?
	public var invokedRemoveParametersList = [(organization: HealthcareOrganization, Void)]()
	public var stubbedRemoveError: Error?

	public func remove(_ organization: HealthcareOrganization) throws {
		invokedRemove = true
		invokedRemoveCount += 1
		invokedRemoveParameters = (organization, ())
		invokedRemoveParametersList.append((organization, ()))
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
