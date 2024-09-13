/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import Zibs

class Loader {
	
	func load() {
		
		for healthcareOrganization in Current.healthcareOrganizationStore.organizations {
			
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
	}
	
	func loadMedication(healthcareOrganization: MgoOrganization) async {
		
		do {
			try await loadResource(
				healthcareOrganization: healthcareOrganization,
				category: .medication
			)
		} catch {
			logError("loadMedication error: \(error)")
		}
	}
	
	func loadResource(healthcareOrganization: MgoOrganization, category: HealthCategories.Category) async throws {
		
		guard let client = FHIRClient() else {
			return
		}
		let repository = MGORepository(client: client)
		
		guard let dvaTarget = healthcareOrganization.getResourceEndpoint(identifier: DVP.CommonClinicalDataset.serviceID) else {
			return
		}
		
		for endpoint in category.endPoint {
			
			let data = try await repository.getBundleData(endpoint: endpoint, dvaTarget: dvaTarget)
			var mgoResources = try repository.process(data)
			
			mgoResources = mgoResources.filter { resource in
				
				var result = false
				for profile in category.acceptedProfiles {
					result = result || resource.hasProfile(profile)
				}
				return result
			}
			#warning("Can we store multiple records for the same category and organization? I think the datastore will overwrite with the latest. Should we append the resources? ")
			let recordToStore = MgoResourceRecord(categoryId: "\(category.rawValue)", organizationId: healthcareOrganization.identifier, resources: mgoResources)
			Current.dataStore.store(data: recordToStore)
		}
	}
}
