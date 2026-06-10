/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
@testable import MGO

class ReferenceResolverSpy: ReferenceResolverProtocol {

	var invokedResolve = false
	var invokedResolveCount = 0
	var invokedResolveParameters: (reference: String, healthcareOrganization: OrganizationSearch.Organization)?
	var invokedResolveParametersList = [(reference: String, healthcareOrganization: OrganizationSearch.Organization)]()
	var stubbedResolveResult: (Data, HealthUISchema)!

	func resolve(
		reference: String,
		healthcareOrganization: OrganizationSearch.Organization
	) -> (Data, HealthUISchema)? {
		
		invokedResolve = true
		invokedResolveCount += 1
		invokedResolveParameters = (reference, healthcareOrganization)
		invokedResolveParametersList.append((reference, healthcareOrganization))
		return stubbedResolveResult
	}
}
