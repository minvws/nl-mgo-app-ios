/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import LocalisationServiceClient

struct StoredHealthcareProviderModel: Codable, Hashable, Equatable, Identifiable {
	var type: String
	var id: String
	var name: String
	var city: String?
	var address: String?
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
		return StoredHealthcareProviderModel(type: "tandarts", id: identifier, name: name, city: city, address: address, postalCode: postalCode)
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
