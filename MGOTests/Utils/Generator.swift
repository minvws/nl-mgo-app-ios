/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

class Generator {
	
	/// Create a healthcare provider
	/// - Parameters:
	///   - id: the identifier of the provider
	///   - city: the city of the provider
	///   - address: the address of the provider
	///   - postalCode: the postal code of the provider
	/// - Returns: a healthcare provider
	static func healthcareProvider(_ id: String, city: String = "Roermond", address: String = "Boorplatform 5", postalCode: String = "1234AB") -> HealthcareProvider {
		return HealthcareProvider(
			display_name: "Tandarts Tandje Erbij",
			identification_type: "type",
			identification_value: id,
			active: true,
			addresses: [Components.Schemas.Address(
				active: true,
				address: "\(address) \r\n \(postalCode) \(city)",
				city: city,
				lines: [address],
				postalcode: postalCode,
				_type: "postal")
			],
			names: [],
			types: [
				Components.Schemas.CType(
					code: "01",
					display_name: "Tandarts",
					_type: ""
				)
			],
			data_services: []
		)
	}
}
