/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import Observatory

public class HealthcareOrganizationRepositorySpy: HealthcareOrganizationRepositoryProtocol {

	public init() { /* Public initializer needed for public access */ }

	public var invokedOrganizationsGetter = false
	public var invokedOrganizationsGetterCount = 0
	public var stubbedOrganizations: [Organization]! = []

	public var organizations: [Organization] {
		invokedOrganizationsGetter = true
		invokedOrganizationsGetterCount += 1
		return stubbedOrganizations
	}

	public var invokedObservatoryGetter = false
	public var invokedObservatoryGetterCount = 0
	public var stubbedObservatory: Observatory<(Organization?, HealthcareOrganizationReason)>!

	public var observatory: Observatory<(Organization?, HealthcareOrganizationReason)> {
		invokedObservatoryGetter = true
		invokedObservatoryGetterCount += 1
		return stubbedObservatory
	}

	public var invokedStore = false
	public var invokedStoreCount = 0
	public var invokedStoreParameters: (organization: Organization, Void)?
	public var invokedStoreParametersList = [(organization: Organization, Void)]()
	public var stubbedStoreError: Error?

	public func store(_ organization: Organization) throws {
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
	public var invokedRemoveParameters: (organization: Organization, Void)?
	public var invokedRemoveParametersList = [(organization: Organization, Void)]()
	public var stubbedRemoveError: Error?

	public func remove(_ organization: Organization) throws {
		invokedRemove = true
		invokedRemoveCount += 1
		invokedRemoveParameters = (organization, ())
		invokedRemoveParametersList.append((organization, ()))
		if let error = stubbedRemoveError {
			throw error
		}
	}

	public var invokedSet = false
	public var invokedSetCount = 0
	public var invokedSetParameters: (newListOfOrganizations: [Organization], Void)?
	public var invokedSetParametersList = [(newListOfOrganizations: [Organization], Void)]()
	public var stubbedSetError: Error?

	public func set(_ newListOfOrganizations: [Organization]) throws {
		invokedSet = true
		invokedSetCount += 1
		invokedSetParameters = (newListOfOrganizations, ())
		invokedSetParametersList.append((newListOfOrganizations, ()))
		if let error = stubbedSetError {
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
