/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

extension MgoOrganization {

	/// Get the number of services for a category
	/// - Parameter category: the category
	/// - Returns: the number of services.
	@MainActor func servicesForCategory(_ category: SharedHealthCategories.Category) -> Int {
		
		var result = 0
		let dataServices = DataServices(isDemo: Container.shared.featureFlagManager().isDemo)
		for dataService in dataServices.services {
			
			// Check if the organization uses this data service
			guard getResourceEndpoint(identifier: dataService.id) != nil else {
				continue
			}
			
			// Set of endpoints to use. a set to filter duplicates
			var usableEndpoints = Set<DataServices.Endpoint>()
			for endpoint in dataService.endpoints {
				for dsProfile in endpoint.profiles {
					for subcategory in category.subcategories {
						for scProfile in subcategory.profiles where scProfile == dsProfile {
							usableEndpoints.insert(endpoint)
						}
					}
				}
			}
			result += usableEndpoints.count
		}
		
		logVerbose("\(result) services found for category \(category)")
		return result
	}
	
	/// Get the number of services for a category
	/// - Parameter category: the category
	/// - Returns: the number of services.
	@MainActor func servicesForCategory(_ category: HealthCategories.Category) -> Int {
		
		var shadowResult = 0
		
		let dataServices = DataServices(isDemo: Container.shared.featureFlagManager().isDemo)
		if let sharedCategory = category.sharedCategory {
			for dataService in dataServices.services {
				
				// Check if the organization uses this data service
				guard getResourceEndpoint(identifier: dataService.id) != nil else {
					continue
				}
				
				// Set of endpoints to use. a set to filter duplicates
				var usableEndpoints = Set<DataServices.Endpoint>()
				for endpoint in dataService.endpoints {
					for dsProfile in endpoint.profiles {
						for subcategory in sharedCategory.subcategories {
							for scProfile in subcategory.profiles where scProfile == dsProfile {
								usableEndpoints.insert(endpoint)
							}
						}
					}
				}
				shadowResult += usableEndpoints.count
			}
		}
		
		logVerbose("\(shadowResult) shadow services found for category \(category)")
		return shadowResult
		
//		for service in category.services {
//			for dataService in organizationDataServices where service.serviceId == dataService.id {
//				logVerbose("Service \(service.serviceId) found for category \(category)")
//				result += 1
//			}
//		}
//		logInfo("\(result) services found for category \(category)")
//		return result
	}
}
