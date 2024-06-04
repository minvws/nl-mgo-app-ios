/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

struct OverviewHealthcareProvider: Codable, Hashable, Equatable, Identifiable {
	
	/// The category of healthcare provider (dentist, gp, etc)
	var category: String
	
	/// The identifier
	var id: String
	
	/// The name of the healthcare provider
	var name: String
}

class OverviewDecorator {
	
	/// Create a OverviewHealthcareProvider from a HealthcareProvider
	/// - Parameter from: HealthcareProvider
	/// - Returns: OverviewHealthcareProvider
	static func create(_ organisation: HealthcareProvider) -> OverviewHealthcareProvider {
		
		let identifier = organisation.identification_type + "|" + organisation.identification_value
		let name = Sanitizer.strip(organisation.display_name) ?? ""
		let category = Sanitizer.strip(organisation.types.first?.display_name) ?? ""

		return OverviewHealthcareProvider(category: category, id: identifier, name: name)
	}
}
