/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import OpenAPIRuntime
import OpenAPIURLSession

public typealias MgoOrganization = Components.Schemas.Organization

public extension Components.Schemas.Organization {
	
	/// What is the category of a healthcare organization?
	var category: String? {
		return types.first?.display_name
	}
	
	/// What data service endpoint should we pass to the proxy?
	func getResourceEndpoint(identifier: Int) -> String? {
		
		let dataService = data_services.first { $0.id == identifier }
		return dataService?.roles.first?.resource_endpoint
	}
	
	/// The identifier of the organization
	var identifier: String {
		return identification_type + "|" + identification_value
	}
}
