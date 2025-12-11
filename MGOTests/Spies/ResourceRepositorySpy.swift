/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
@testable import MGO

class ResourceRepositorySpy: ResourceRepositoryProtocol {
	
	private let queue = DispatchQueue(label: "com.ResourceRepositorySpy.serialqueue.\(UUID().uuidString)")

	var invokedLoad = false
	var invokedLoadCount = 0
	
	func load() {
		queue.sync {
			invokedLoad = true
			invokedLoadCount += 1
		}
	}
	
	var invokedLoadForMgoOrganization = false
	var invokedLoadForMgoOrganizationCount = 0
	var invokedLoadForMgoOrganizationParameters: (healthcareOrganization: MgoOrganization, Void)?
	var invokedLoadForMgoOrganizationParametersList = [(healthcareOrganization: MgoOrganization, Void)]()
	
	func loadFor(_ healthcareOrganization: MgoOrganization) {
		queue.sync {
			invokedLoadForMgoOrganization = true
			invokedLoadForMgoOrganizationCount += 1
			invokedLoadForMgoOrganizationParameters = (healthcareOrganization, ())
			invokedLoadForMgoOrganizationParametersList.append((healthcareOrganization, ()))
		}
	}
	
	var invokedLoadForSharedHealthCategoriesCategories = false
	var invokedLoadForSharedHealthCategoriesCategoriesCount = 0
	var invokedLoadForSharedHealthCategoriesCategoriesParameters: (categories: [SharedHealthCategories.Category], Void)?
	var invokedLoadForSharedHealthCategoriesCategoriesParametersList = [(categories: [SharedHealthCategories.Category], Void)]()
	
	func loadFor(_ categories: [SharedHealthCategories.Category]) {
		queue.sync {
			invokedLoadForSharedHealthCategoriesCategories = true
			invokedLoadForSharedHealthCategoriesCategoriesCount += 1
			invokedLoadForSharedHealthCategoriesCategoriesParameters = (categories, ())
			invokedLoadForSharedHealthCategoriesCategoriesParametersList.append((categories, ()))
		}
	}
	
	var invokedLoadResource = false
	var invokedLoadResourceCount = 0
	var invokedLoadResourceParameters: (healthcareOrganization: MgoOrganization, categories: [SharedHealthCategories.Category])?
	var invokedLoadResourceParametersList = [(healthcareOrganization: MgoOrganization, categories: [SharedHealthCategories.Category])]()
	
	func loadResource(_ healthcareOrganization: MgoOrganization, categories: [SharedHealthCategories.Category]) {
		queue.sync {
			invokedLoadResource = true
			invokedLoadResourceCount += 1
			invokedLoadResourceParameters = (healthcareOrganization, categories)
			invokedLoadResourceParametersList.append((healthcareOrganization, categories))
		}
	}
	
	var invokedLoadBinary = false
	var invokedLoadBinaryCount = 0
	var invokedLoadBinaryParameters: (healthcareOrganization: MgoOrganization, serviceId: String, url: String)?
	var invokedLoadBinaryParametersList = [(healthcareOrganization: MgoOrganization, serviceId: String, url: String)]()
	var stubbedLoadBinary: FHIRBinary?
	var stubbedLoadBinaryError: Error?
	
	func loadBinary(_ healthcareOrganization: MgoOrganization, serviceId: String, path: String) async throws -> FHIRBinary? {
		
		queue.sync {
			invokedLoadBinary = true
			invokedLoadBinaryCount += 1
			invokedLoadBinaryParameters = (healthcareOrganization, serviceId, path)
			invokedLoadBinaryParametersList.append((healthcareOrganization, serviceId, path))
		}
		if let error = stubbedLoadBinaryError {
			throw error
		}
		return stubbedLoadBinary
	}

	var invokedGetVersion = false
	var invokedGetVersionCount = 0
	var stubbedGetVersionError: Error?
	var stubbedGetVersionResult: SharedVersion!

	func getVersion() throws -> SharedVersion {
		invokedGetVersion = true
		invokedGetVersionCount += 1
		if let error = stubbedGetVersionError {
			throw error
		}
		return stubbedGetVersionResult
	}
}
