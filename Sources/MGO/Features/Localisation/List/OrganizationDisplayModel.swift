/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

struct OrganizationDisplayModel: Codable, Hashable, Equatable, Identifiable {
	var id: String
	var name: String
	var city: String?
	var address: String?
	var postalCode: String?
}

class OrganizationDisplayDecorator {
	
	/// Create a SearchResult from a HealthcareOrganization
	/// - Parameter from: HealthcareOrganization
	/// - Returns: SearchResult
	static func create(_ organisation: MgoOrganization) -> OrganizationDisplayModel {
		
		let identifier = organisation.identifier
		let name = Sanitizer.strip(organisation.display_name) ?? ""
		let (address, city, postalCode) = organisation.getAddress()
		return OrganizationDisplayModel(
			id: identifier,
			name: name,
			city: Sanitizer.strip(city),
			address: Sanitizer.strip(address),
			postalCode: Sanitizer.strip(postalCode)
		)
	}
}
