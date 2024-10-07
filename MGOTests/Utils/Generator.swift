/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import Zibs

class Generator {
	
	/// Create a healthcare organization
	/// - Parameters:
	///   - id: the identifier of the organization
	///   - city: the city of the organization
	///   - address: the address of the organization
	///   - postalCode: the postal code of the organization
	/// - Returns: a healthcare organization
	static func healthcareOrganization(_ id: String, city: String = "Roermond", address: String = "Boorplatform 5", postalCode: String = "1234AB", useDataService: Bool = true ) -> MgoOrganization {
		
		var dataServices = [LocalisationService.Components.Schemas.ZalDataServiceResponse]()
		if useDataService {
			dataServices.append(
				LocalisationService.Components.Schemas.ZalDataServiceResponse(
					id: "48",
					name: "Basisgegevens Zorg",
					interface_versions: ["2"],
					auth_endpoint: "https://medmij-inlog.vzvz.nl/2.0.0/oauth2/authorize",
					token_endpoint: "https://medmij-inlog.vzvz.nl/2.0.0/oauth2/token",
					roles: [
						LocalisationService.Components.Schemas.ZalDataServiceRoleResponse(
							code: "MM-3.0-BZB-FHIR",
							resource_endpoint: "https://dva-mock.test.mgo.prolocation.net/48")
					]
				)
			)
		}
		
		return MgoOrganization(
			medmij_id: "test",
			display_name: "Tandarts Tandje Erbij",
			identification: id,
			addresses: [LocalisationService.Components.Schemas.Address(
				active: true,
				address: "\(address) \r\n \(postalCode) \(city)",
				city: city,
				lines: [address],
				postalcode: postalCode,
				_type: "postal")
			],
			types: [
				LocalisationService.Components.Schemas.CType(
					code: "01",
					display_name: "Tandarts",
					_type: ""
				)
			],
			data_services: dataServices
		)
	}
}
