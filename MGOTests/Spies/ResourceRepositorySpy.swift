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

	var invokedLoadForSharedHealthCategoriesCategory = false
	var invokedLoadForSharedHealthCategoriesCategoryCount = 0
	var invokedLoadForSharedHealthCategoriesCategoryParameters: (category: SharedHealthCategories.Category, Void)?
	var invokedLoadForSharedHealthCategoriesCategoryParametersList = [(category: SharedHealthCategories.Category, Void)]()

	func loadFor(_ category: SharedHealthCategories.Category) {
		invokedLoadForSharedHealthCategoriesCategory = true
		invokedLoadForSharedHealthCategoriesCategoryCount += 1
		invokedLoadForSharedHealthCategoriesCategoryParameters = (category, ())
		invokedLoadForSharedHealthCategoriesCategoryParametersList.append((category, ()))
	}

	var invokedLoadResourceMgoOrganizationCategoryHealthCategoriesCategory = false
	var invokedLoadResourceMgoOrganizationCategoryHealthCategoriesCategoryCount = 0
	var invokedLoadResourceMgoOrganizationCategoryHealthCategoriesCategoryParameters: (healthcareOrganization: MgoOrganization, category: HealthCategories.Category)?
	var invokedLoadResourceMgoOrganizationCategoryHealthCategoriesCategoryParametersList = [(healthcareOrganization: MgoOrganization, category: HealthCategories.Category)]()

	func loadResource(_ healthcareOrganization: MgoOrganization, category: HealthCategories.Category) {
		invokedLoadResourceMgoOrganizationCategoryHealthCategoriesCategory = true
		invokedLoadResourceMgoOrganizationCategoryHealthCategoriesCategoryCount += 1
		invokedLoadResourceMgoOrganizationCategoryHealthCategoriesCategoryParameters = (healthcareOrganization, category)
		invokedLoadResourceMgoOrganizationCategoryHealthCategoriesCategoryParametersList.append((healthcareOrganization, category))
	}

	var invokedLoadResourceMgoOrganizationCategorySharedHealthCategoriesCategory = false
	var invokedLoadResourceMgoOrganizationCategorySharedHealthCategoriesCategoryCount = 0
	var invokedLoadResourceMgoOrganizationCategorySharedHealthCategoriesCategoryParameters: (healthcareOrganization: MgoOrganization, category: SharedHealthCategories.Category)?
	var invokedLoadResourceMgoOrganizationCategorySharedHealthCategoriesCategoryParametersList = [(healthcareOrganization: MgoOrganization, category: SharedHealthCategories.Category)]()

	func loadResource(_ healthcareOrganization: MgoOrganization, category: SharedHealthCategories.Category) {
		invokedLoadResourceMgoOrganizationCategorySharedHealthCategoriesCategory = true
		invokedLoadResourceMgoOrganizationCategorySharedHealthCategoriesCategoryCount += 1
		invokedLoadResourceMgoOrganizationCategorySharedHealthCategoriesCategoryParameters = (healthcareOrganization, category)
		invokedLoadResourceMgoOrganizationCategorySharedHealthCategoriesCategoryParametersList.append((healthcareOrganization, category))
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
