/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

struct PreviewContent {
	
	static let healthcareOrganization = MgoOrganization(
		medmij_id: "test",
		display_name: "Tandarts Tandje Erbij",
		identification: "1",
		addresses: [LocalisationService.Components.Schemas.Address(
			active: true,
			address: "Boorplatform 5",
			city: "Roermond",
			lines: ["Boorplatform 5"],
			postalcode: "1234AB",
			_type: "postal")
		],
		types: [LocalisationService.Components.Schemas.CType(code: "01", display_name: "Tandarts", _type: "")],
		data_services: []
	)
}
