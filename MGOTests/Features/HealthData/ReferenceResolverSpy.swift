/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
@testable import MGO

class ReferenceResolverSpy: ReferenceResolverProtocol {

	var invokedResolve = false
	var invokedResolveCount = 0
	var invokedResolveParameters: (reference: String, healthcareOrganization: MgoOrganization)?
	var invokedResolveParametersList = [(reference: String, healthcareOrganization: MgoOrganization)]()
	var stubbedResolveResult: (Data, HealthUISchema)!

	func resolve(reference: String, healthcareOrganization: MgoOrganization) -> (Data, HealthUISchema)? {
		invokedResolve = true
		invokedResolveCount += 1
		invokedResolveParameters = (reference, healthcareOrganization)
		invokedResolveParametersList.append((reference, healthcareOrganization))
		return stubbedResolveResult
	}
}
