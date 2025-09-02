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
			postalcode: "1234AB")
		],
		types: [LocalisationService.Components.Schemas.CType(code: "01", display_name: "Tandarts", _type: "")],
		data_services: []
	)
	
	static let category = SharedHealthCategories.Category(
		id: "medication",
		heading: "hc_medication.heading",
		subheading: "hc_medication.subheading",
		subcategories: [
			SharedHealthCategories.SubCategory(
				heading: "zib_medication_use.heading",
				profiles: ["http://nictiz.nl/fhir/StructureDefinition/zib-MedicationUse"]
			),
			SharedHealthCategories.SubCategory(
				heading: "zib_medication_agreement.heading",
				profiles: ["http://nictiz.nl/fhir/StructureDefinition/zib-MedicationAgreement"]
			),
			SharedHealthCategories.SubCategory(
				heading: "zib_administration_agreement.heading",
				profiles: ["http://nictiz.nl/fhir/StructureDefinition/zib-AdministrationAgreement"]
			)
		]
	)
}
