/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

struct SearchResult: Codable, Hashable, Equatable, Identifiable {
	var id: String
	var name: String
	var city: String?
	var address: String?
	var postalCode: String?
}

class SearchResultDecorator {
	
	/// Create a SearchResult from a HealthcareProvider
	/// - Parameter from: HealthcareProvider
	/// - Returns: SearchResult
	static func create(_ organisation: HealthcareProvider) -> SearchResult {
		
		let identifier = organisation.identification_type + "|" + organisation.identification_value
		let name = organisation.display_name // + " [\(identifier)]"
		let (address, city, postalCode) = organisation.getAddress()
		return SearchResult(id: identifier, name: name, city: city, address: address, postalCode: postalCode)
	}
}
