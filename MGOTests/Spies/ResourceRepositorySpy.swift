/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
@testable import MGO

class ResourceRepositorySpy: ResourceRepositoryProtocol {

	var invokedLoad = false
	var invokedLoadCount = 0

	func load() {
		invokedLoad = true
		invokedLoadCount += 1
	}

	var invokedLoadFor = false
	var invokedLoadForCount = 0
	var invokedLoadForParameters: (healthcareOrganization: MgoOrganization, Void)?
	var invokedLoadForParametersList = [(healthcareOrganization: MgoOrganization, Void)]()

	func loadFor(_ healthcareOrganization: MgoOrganization) {
		invokedLoadFor = true
		invokedLoadForCount += 1
		invokedLoadForParameters = (healthcareOrganization, ())
		invokedLoadForParametersList.append((healthcareOrganization, ()))
	}
}
