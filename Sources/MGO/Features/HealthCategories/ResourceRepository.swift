/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import Zibs

protocol ResourceRepositoryProtocol {
	
	/// Load all the categories for all the stored healthcare organizations
	func load()
	
	/// Load all the categories for a healthcare organization
	/// - Parameter healthcareOrganization: the healthcare organization to load all the categories for
	func loadFor(_ healthcareOrganization: MgoOrganization)
}

class ResourceRepository: ResourceRepositoryProtocol {
	
	/// Load all the categories for a healthcare organization
	/// - Parameter healthcareOrganization: the healthcare organization to load all the categories for
	func loadFor(_ healthcareOrganization: MgoOrganization) {
		for category in HealthCategories.Category.allCases {
			
			switch category {
				case .medication:
					_Concurrency.Task { await loadMedication(healthcareOrganization: healthcareOrganization) }
				case .allergies:
					break
				case .measurements:
					break
				case .vaccinations:
					break
				case .complaints:
					break
				case .treatments:
					break
				case .labresults:
					break
				case .reports:
					break
				case .documents:
					break
			}
		}
	}
	
	/// Load all the categories for all the stored healthcare organizations
	func load() {
		
		for healthcareOrganization in Current.healthcareOrganizationStore.organizations {
			loadFor(healthcareOrganization)
		}
	}
	
	/// Load the medications for a healthcare organization
	/// - Parameter healthcareOrganization: healthcare organization
	private func loadMedication(healthcareOrganization: MgoOrganization) async {
		
		do {
			try await loadResource(
				healthcareOrganization: healthcareOrganization,
				category: .medication
			)
		} catch {
			logError("loadMedication error: \(error)")
		}
	}
	
	/// Load the resources
	/// - Parameters:
	///   - healthcareOrganization: healthcare organization
	///   - category: the category to load the resources for.
	private func loadResource(healthcareOrganization: MgoOrganization, category: HealthCategories.Category) async throws {
		
		guard let client = FHIRClient() else {
			return
		}
		let repository = MGORepository(client: client)
		
		guard let dvaTarget = healthcareOrganization.getResourceEndpoint(identifier: DVP.CommonClinicalDataset.serviceID) else {
			return
		}
		
		for endpoint in category.endPoint {
			logVerbose("Loader: calling endpoint for \(dvaTarget)", endpoint)
			let data = try await repository.getBundleData(endpoint: endpoint, dvaTarget: dvaTarget)
			var mgoResources = try repository.process(data)
			
			mgoResources = mgoResources.filter { resource in
				
				var result = false
				for profile in category.acceptedProfiles {
					result = result || resource.hasProfile(profile)
				}
				return result
			}
			
			let recordToStore = MgoResourceRecord(categoryId: "\(category.rawValue)", organizationId: healthcareOrganization.identifier, resources: mgoResources)
			Current.dataStore.store(data: recordToStore)
		}
	}
}
