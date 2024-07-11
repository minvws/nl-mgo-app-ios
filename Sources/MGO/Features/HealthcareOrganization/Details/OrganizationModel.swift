/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

struct OrganizationModel: Codable, Hashable, Equatable, Identifiable {
	
	/// The category of healthcare organization (dentist, gp, etc)
	var category: String
	
	/// The identifier
	var id: String
	
	/// The name of the healthcare organization
	var name: String
}

class OrganizationDecorator {
	
	/// Create a OverviewModel from a HealthcareOrganization
	/// - Parameter from: HealthcareOrganization
	/// - Returns: OverviewHealthcareOrganization
	static func create(_ organisation: MgoOrganization) -> OrganizationModel {
		
		let identifier = organisation.identification_type + "|" + organisation.identification_value
		let name = organisation.display_name // + " [\(identifier)]"

		return OrganizationModel(
			category: Sanitizer.strip(organisation.types.first?.display_name) ?? "",
			id: identifier,
			name: Sanitizer.sanitize(name)
		)
	}
}
