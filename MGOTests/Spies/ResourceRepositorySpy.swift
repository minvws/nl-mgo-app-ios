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
	
	var invokedLoadForSharedHealthCategoriesCategory = false
	var invokedLoadForSharedHealthCategoriesCategoryCount = 0
	var invokedLoadForSharedHealthCategoriesCategoryParameters: (category: SharedHealthCategories.Category, Void)?
	var invokedLoadForSharedHealthCategoriesCategoryParametersList = [(category: SharedHealthCategories.Category, Void)]()
	
	func loadFor(_ category: SharedHealthCategories.Category) {
		queue.sync {
			invokedLoadForSharedHealthCategoriesCategory = true
			invokedLoadForSharedHealthCategoriesCategoryCount += 1
			invokedLoadForSharedHealthCategoriesCategoryParameters = (category, ())
			invokedLoadForSharedHealthCategoriesCategoryParametersList.append((category, ()))
		}
	}
	
	var invokedLoadResource = false
	var invokedLoadResourceCount = 0
	var invokedLoadResourceParameters: (healthcareOrganization: MgoOrganization, category: SharedHealthCategories.Category)?
	var invokedLoadResourceParametersList = [(healthcareOrganization: MgoOrganization, category: SharedHealthCategories.Category)]()
	
	func loadResource(_ healthcareOrganization: MgoOrganization, category: SharedHealthCategories.Category) {
		queue.sync {
			invokedLoadResource = true
			invokedLoadResourceCount += 1
			invokedLoadResourceParameters = (healthcareOrganization, category)
			invokedLoadResourceParametersList.append((healthcareOrganization, category))
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
