/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

struct OrganizationListModel: Codable, Hashable, Equatable, Identifiable {
	
	/// The category of a healthcare organization (dentist, gp, etc)
	var category: String
	
	/// The identifier
	var id: String
	
	/// The name of the healthcare organization
	var name: String
	
	/// The city of the healthcare organization
	var city: String?
	
	/// The address of the healthcare organization
	var address: String?
	
	/// The postal code of the healthcare organization
	var postalCode: String?
}

class OrganizationListDecorator {
	
	/// Create a OrganizationListModel from a HealthcareOrganization
	/// - Parameter from: HealthcareOrganization
	/// - Returns: OrganizationListModel
	static func create(_ organisation: HealthcareOrganization) -> OrganizationListModel {
		
		let identifier = organisation.identification_type + "|" + organisation.identification_value
		let name = Sanitizer.strip(organisation.display_name) ?? ""
		let (address, city, postalCode) = organisation.getAddress()
		let category = Sanitizer.strip(organisation.category) ?? ""
		
		return OrganizationListModel(
			category: category,
			id: identifier,
			name: name,
			city: Sanitizer.strip(city),
			address: Sanitizer.strip(address),
			postalCode: Sanitizer.strip(postalCode)
		)
	}
}
