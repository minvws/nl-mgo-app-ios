/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
@testable import MGO

class ResourceRepositorySpy: ResourceRepositoryProtocol, @unchecked Sendable {
	
	private let queue = DispatchQueue(label: "com.ResourceRepositorySpy.serialqueue.\(UUID().uuidString)")

	var invokedLoad = false
	var invokedLoadCount = 0
	
	func load() {
		queue.sync {
			invokedLoad = true
			invokedLoadCount += 1
		}
	}
	
	var invokedLoadForOrganization = false
	var invokedLoadForOrganizationCount = 0
	var invokedLoadForOrganizationParameters: (healthcareOrganization: OrganizationSearch.Organization, Void)?
	var invokedLoadForOrganizationParametersList = [(healthcareOrganization: OrganizationSearch.Organization, Void)]()
	
	func loadFor(_ healthcareOrganization: OrganizationSearch.Organization) {
		queue.sync {
			invokedLoadForOrganization = true
			invokedLoadForOrganizationCount += 1
			invokedLoadForOrganizationParameters = (healthcareOrganization, ())
			invokedLoadForOrganizationParametersList.append((healthcareOrganization, ()))
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
	var invokedLoadResourceParameters: (healthcareOrganization: OrganizationSearch.Organization, categories: [SharedHealthCategories.Category])?
	var invokedLoadResourceParametersList = [(healthcareOrganization: OrganizationSearch.Organization, categories: [SharedHealthCategories.Category])]()
	
	func loadResource(_ healthcareOrganization: OrganizationSearch.Organization, categories: [SharedHealthCategories.Category]) {
		queue.sync {
			invokedLoadResource = true
			invokedLoadResourceCount += 1
			invokedLoadResourceParameters = (healthcareOrganization, categories)
			invokedLoadResourceParametersList.append((healthcareOrganization, categories))
		}
	}
	
	var invokedLoadBinary = false
	var invokedLoadBinaryCount = 0
	var invokedLoadBinaryParameters: (healthcareOrganization: OrganizationSearch.Organization, serviceId: String, url: String)?
	var invokedLoadBinaryParametersList = [(healthcareOrganization: OrganizationSearch.Organization, serviceId: String, url: String)]()
	var stubbedLoadBinary: FHIRBinary?
	var stubbedLoadBinaryError: Error?
	
	func loadBinary(_ healthcareOrganization: OrganizationSearch.Organization, serviceId: String, path: String) async throws -> FHIRBinary? {
		
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
	var stubbedGetVersionResult: SharedCategoriesVersion!

	func getVersion() async throws -> SharedCategoriesVersion {
		invokedGetVersion = true
		invokedGetVersionCount += 1
		if let error = stubbedGetVersionError {
			throw error
		}
		return stubbedGetVersionResult
	}
}
