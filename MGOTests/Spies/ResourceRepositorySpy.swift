/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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

	var invokedLoadForMgoOrganization = false
	var invokedLoadForMgoOrganizationCount = 0
	var invokedLoadForMgoOrganizationParameters: (healthcareOrganization: MgoOrganization, Void)?
	var invokedLoadForMgoOrganizationParametersList = [(healthcareOrganization: MgoOrganization, Void)]()

	func loadFor(_ healthcareOrganization: MgoOrganization) {
		invokedLoadForMgoOrganization = true
		invokedLoadForMgoOrganizationCount += 1
		invokedLoadForMgoOrganizationParameters = (healthcareOrganization, ())
		invokedLoadForMgoOrganizationParametersList.append((healthcareOrganization, ()))
	}

	var invokedLoadForHealthCategoriesCategory = false
	var invokedLoadForHealthCategoriesCategoryCount = 0
	var invokedLoadForHealthCategoriesCategoryParameters: (category: HealthCategories.Category, Void)?
	var invokedLoadForHealthCategoriesCategoryParametersList = [(category: HealthCategories.Category, Void)]()

	func loadFor(_ category: HealthCategories.Category) {
		invokedLoadForHealthCategoriesCategory = true
		invokedLoadForHealthCategoriesCategoryCount += 1
		invokedLoadForHealthCategoriesCategoryParameters = (category, ())
		invokedLoadForHealthCategoriesCategoryParametersList.append((category, ()))
	}

	var invokedLoadResource = false
	var invokedLoadResourceCount = 0
	var invokedLoadResourceParameters: (healthcareOrganization: MgoOrganization, category: HealthCategories.Category)?
	var invokedLoadResourceParametersList = [(healthcareOrganization: MgoOrganization, category: HealthCategories.Category)]()

	func loadResource(_ healthcareOrganization: MgoOrganization, category: HealthCategories.Category) {
		invokedLoadResource = true
		invokedLoadResourceCount += 1
		invokedLoadResourceParameters = (healthcareOrganization, category)
		invokedLoadResourceParametersList.append((healthcareOrganization, category))
	}

	var invokedLoadBinary = false
	var invokedLoadBinaryCount = 0
	var invokedLoadBinaryParameters: (healthcareOrganization: MgoOrganization, serviceId: String, url: String)?
	var invokedLoadBinaryParametersList = [(healthcareOrganization: MgoOrganization, serviceId: String, url: String)]()
	var stubbedLoadBinary: FHIRBinary?
	var stubbedLoadBinaryError: Error?

	private let queue = DispatchQueue(label: "com.ResourceRepositorySpy.serialqueue.\(UUID().uuidString)")

	func loadBinary(_ healthcareOrganization: MgoOrganization, serviceId: String, url: String) async throws -> FHIRBinary? {
			
		queue.sync {
			invokedLoadBinary = true
			invokedLoadBinaryCount += 1
			invokedLoadBinaryParameters = (healthcareOrganization, serviceId, url)
			invokedLoadBinaryParametersList.append((healthcareOrganization, serviceId, url))
		}
		if let error = stubbedLoadBinaryError {
			throw error
		}
		return stubbedLoadBinary
	}
}
