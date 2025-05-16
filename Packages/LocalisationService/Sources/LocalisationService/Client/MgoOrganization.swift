/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import OpenAPIRuntime
import OpenAPIURLSession

public typealias MgoOrganization = Components.Schemas.Organization

public typealias DataService = Components.Schemas.ZalDataServiceResponse

public extension Components.Schemas.Organization {
	
	/// What is the category of a healthcare organization?
	var category: String? {
		return types.first?.display_name
	}
	
	/// What data service endpoint should we pass to the proxy?
	func getResourceEndpoint(identifier: String) -> String? {
		
		let dataService = data_services?.first { $0.id == identifier }
		return dataService?.roles.first?.resource_endpoint
	}
	
	/// The identifier of the organization
	var identifier: String {
		return identification
	}
}
