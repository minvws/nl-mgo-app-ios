/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import LocalisationServiceClient

struct SearchResult: Codable, Hashable, Equatable {
	var id: String
	var name: String
	var city: String?
	var address: String?
	var postalCode: String?
}

class SearchResultDecorator {
	
	/// Create a SearchResult from a Component.Schema.Organization
	/// - Parameter from: Component.Schema.Organization
	/// - Returns: SearchResult
	static func create(_ organisation: Components.Schemas.Organization) -> SearchResult {
		
		let identifier = organisation.identification_type + "|" + organisation.identification_value
		let name = organisation.display_name // + " [\(identifier)]"
		let city = organisation.addresses.first?.city
		let postalCode = organisation.addresses.first?.postalcode
		var address = organisation.addresses.first?.address
		if let city {
			address = address?.replacingOccurrences(of: city, with: "")
		}
		if let postalCode {
			address = address?.replacingOccurrences(of: postalCode, with: "")
		}
		if address != nil {
			address = address!.trimmingCharacters(in: .whitespacesAndNewlines)
		}
		return SearchResult(id: identifier, name: name, city: city, address: address, postalCode: postalCode)
	}
	
	/// Create an array of SearchResults from an array of Component.Schema.Organizations
	/// - Parameter from: array of Component.Schema.Organization
	/// - Returns: array of search results
	static func create(_ from: [Components.Schemas.Organization]) -> [SearchResult] {
		
		var result = [SearchResult]()
		from.forEach { organisation in
			result.append( create(organisation))
		}
		return result
	}
}
