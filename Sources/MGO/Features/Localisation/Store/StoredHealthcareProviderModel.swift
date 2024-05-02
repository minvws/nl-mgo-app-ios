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
	
	/// Create a SearchResult from a HealthcareProvider
	/// - Parameter from: HealthcareProvider
	/// - Returns: SearchResult
	static func create(_ organisation: HealthcareProvider) -> StoredHealthcareProviderModel {
		
		let identifier = organisation.identification_type + "|" + organisation.identification_value
		let name = organisation.display_name // + " [\(identifier)]"
		let (address, city, postalCode) = organisation.getAddress()
		return StoredHealthcareProviderModel(category: organisation.types.first?.display_name ?? "", id: identifier, name: name, city: city, address: address, postalCode: postalCode)
	}
	
	/// Create an array of SearchResults from an array of HealthcareProviders
	/// - Parameter from: array of HealthcareProvider
	/// - Returns: array of search results
	static func create(_ from: [HealthcareProvider]) -> [StoredHealthcareProviderModel] {
		
		var result = [StoredHealthcareProviderModel]()
		from.forEach { organisation in
			result.append( create(organisation))
		}
		return result
	}
}
