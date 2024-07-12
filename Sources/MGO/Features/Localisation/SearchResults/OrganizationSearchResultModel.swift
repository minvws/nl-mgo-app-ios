/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

struct OrganizationSearchResult: Codable, Hashable, Equatable, Identifiable {
	var id: String
	var name: String
	var city: String?
	var address: String?
	var postalCode: String?
}

class OrganizationSearchResultDecorator {
	
	/// Create a SearchResult from a HealthcareOrganization
	/// - Parameter from: HealthcareOrganization
	/// - Returns: SearchResult
	static func create(_ organisation: MgoOrganization) -> OrganizationSearchResult {
		
		let identifier = organisation.identification_type + "|" + organisation.identification_value
		let name = Sanitizer.strip(organisation.display_name) ?? ""
		let (address, city, postalCode) = organisation.getAddress()
		return OrganizationSearchResult(id: identifier, name: name, city: Sanitizer.strip(city), address: Sanitizer.strip(address), postalCode: Sanitizer.strip(postalCode))
	}
}
