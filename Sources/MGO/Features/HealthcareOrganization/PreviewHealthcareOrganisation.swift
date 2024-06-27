/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

struct PreviewContent {
	
	static let healthcareOrganization = HealthcareProvider(
		display_name: "Tandarts Tandje Erbij",
		identification_type: "type",
		identification_value: "1",
		active: true,
		addresses: [Components.Schemas.Address(
			active: true,
			address: "Boorplatform 5",
			city: "Roermond",
			lines: ["Boorplatform 5"],
			postalcode: "1234AB",
			_type: "postal")
		],
		names: [],
		types: [Components.Schemas.CType(code: "01", display_name: "Tandarts", _type: "")],
		data_services: []
	)
}
