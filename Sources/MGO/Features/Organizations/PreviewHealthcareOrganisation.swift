/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import OrganizationSearch

struct PreviewContent {

	static let healthcareOrganization = OrganizationSearch.Organization(
		address: OrganizationSearch.OrganizationAddress(
			addressLine: "Boorplatform 5",
			city: "Roermond",
			postalCode: "1234AB"
		),
		careTypeDisplay: "Tandarts",
		displayName: "Tandarts Tandje Erbij",
		id: "1"
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
