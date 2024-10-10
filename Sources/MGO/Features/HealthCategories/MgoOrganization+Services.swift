/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

extension MgoOrganization {
	
	/// Get the number of services for a category
	/// - Parameter category: the category
	/// - Returns: the number of services.
	func servicesForCategory(_ category: HealthCategories.Category) -> Int {
		
		var result = 0
		guard let dts = data_services else {
			return result
		}
		
		for service in category.services {
			for dataService in dts where service.serviceID == dataService.id {
				result += 1
			}
		}
		return result
	}
}
