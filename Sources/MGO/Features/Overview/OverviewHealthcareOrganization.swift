/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

struct OverviewHealthcareOrganization: Codable, Hashable, Equatable, Identifiable {
	
	/// The category of a healthcare organization (dentist, gp, etc)
	var category: String
	
	/// The identifier
	var id: String
	
	/// The name of the healthcare organization
	var name: String
}

class OverviewDecorator {
	
	/// Create a OverviewHealthcareOrganization from a HealthcareOrganization
	/// - Parameter from: HealthcareOrganization
	/// - Returns: OverviewHealthcareOrganization
	static func create(_ organisation: MgoOrganization) -> OverviewHealthcareOrganization {
		
		let identifier = organisation.identification_type + "|" + organisation.identification_value
		let name = Sanitizer.strip(organisation.display_name) ?? ""
		let category = Sanitizer.strip(organisation.category) ?? ""

		return OverviewHealthcareOrganization(category: category, id: identifier, name: name)
	}
}
