/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

struct StoredHealthcareProviderModel: Codable, Hashable, Equatable, Identifiable {
	
	/// The category of healthcare provider (dentist, gp, etc)
	var category: String
	
	/// The identifier
	var id: String
	
	/// The name of the healthcare provider
	var name: String
	
	/// The city of the healthcare provider
	var city: String?
	
	/// The address of the healthcare provider
	var address: String?
	
	/// The postal code of the healthcare provider
	var postalCode: String?
}

class StoredHealthcareProviderDecorator {
	
	/// Create a StoredHealthcareProviderModel from a HealthcareProvider
	/// - Parameter from: HealthcareProvider
	/// - Returns: StoredHealthcareProviderModel
	static func create(_ organisation: HealthcareProvider) -> StoredHealthcareProviderModel {
		
		let identifier = organisation.identification_type + "|" + organisation.identification_value
		let name = Sanitizer.strip(organisation.display_name) ?? ""
		let (address, city, postalCode) = organisation.getAddress()
		let category = Sanitizer.strip(organisation.types.first?.display_name) ?? ""
		
		return StoredHealthcareProviderModel(
			category: category,
			id: identifier,
			name: name,
			city: Sanitizer.strip(city),
			address: Sanitizer.strip(address),
			postalCode: Sanitizer.strip(postalCode)
		)
	}
}
