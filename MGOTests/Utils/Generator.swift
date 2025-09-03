/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
@testable import MGO

class Generator {
	
	/// Create a healthcare organization
	/// - Parameters:
	///   - id: the identifier of the organization
	///   - name: the name of the organization
	///   - city: the city of the organization
	///   - address: the address of the organization
	///   - postalCode: the postal code of the organization
	///   - useDataService: should we include a data service?
	///   - serviceId: the id for the data service
	///   - withLines: use address as input for the lines part?
	/// - Returns: a healthcare organization
	static func healthcareOrganization(_ id: String, name: String = "Tandarts Tandje Erbij", city: String = "Roermond", address: String = "Boorplatform 5", postalCode: String = "1234AB", useDataService: Bool = true, serviceId: String = "48", withLines: Bool = true ) -> MgoOrganization {
		
		var dataServices = [DataService]()
		if useDataService {
			dataServices.append(
				DataService(
					id: serviceId,
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
			display_name: name,
			identification: id,
			addresses: [LocalisationService.Components.Schemas.Address(
				active: true,
				address: "\(address) \r\n \(postalCode) \(city)",
				city: city,
				lines: withLines ? [address] : nil,
				postalcode: postalCode)
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
	
	/// Return a dummy health sub category
	static func healthCategoryBlock() -> HealthCategoryBlock {
		
		return HealthCategoryBlock(
			heading: "heading subcategory",
			rows: [
				healthCategoryRow()
			]
		)
	}
	
	// swiftlint: disable function_body_length
	/// Create a dummy health category row
	static func healthCategoryRow() -> HealthCategoryRow {
		
		return HealthCategoryRow(
			heading: "heading",
			subHeading: "healthcare organization",
			schema: HealthUISchema(
				children: [
					// Schema Group 1
					HealthUIGroup(
						children: [
							UIElement(
								display: UIElementDisplay.string("single value"),
								label: "label single value",
								type: .singleValue,
								reference: nil,
								url: nil
							),
							UIElement(
								display: nil,
								label: "label reference value",
								type: .referenceValue,
								reference: "reference",
								url: nil
							),
							UIElement(
								display: UIElementDisplay.string("single value"),
								label: "label reference value display",
								type: .referenceValue,
								reference: "reference",
								url: nil
							),
							UIElement(
								display: nil,
								label: "label reference link",
								type: .referenceLink,
								reference: "reference",
								url: "Ref/123"
							),
							UIElement(
								display: nil,
								label: "label download link",
								type: .downloadLink,
								reference: nil,
								url: "https://www.apple.com"
							),
							UIElement(
								display: nil,
								label: "label download reference",
								type: .downloadBinary,
								reference: "reference",
								url: nil
							)
						],
						label: "Section Header first group"
					),
					// Schema Group 2
					HealthUIGroup(
						children: [
							// Unknown
							UIElement(
								display: nil,
								label: "label single value nil",
								type: .singleValue,
								reference: nil,
								url: nil
							),
							UIElement(
								display: UIElementDisplay.unionArray([
									DisplayElement.stringArray(["five", "six"])
								]),
								label: "label multiple group value",
								type: .multipleGroupedValues,
								reference: nil,
								url: nil
							),
							UIElement(
								display: UIElementDisplay.unionArray([
									DisplayElement.string("one"),
									DisplayElement.string("two")
								]),
								label: "label multiple value",
								type: .multipleValues,
								reference: nil,
								url: nil
							),
							UIElement(
								display: UIElementDisplay.unionArray([DisplayElement.string("one")]),
								label: "label union value",
								type: .multipleValues,
								reference: nil,
								url: nil
							),
							UIElement(
								display: UIElementDisplay.unionArray([
									DisplayElement.stringArray(["one", "two"]),
									DisplayElement.stringArray(["three", "four"])
								]),
								label: "label multiple group value",
								type: .multipleGroupedValues,
								reference: nil,
								url: nil
							)
						],
						label: "Section Header second group")
				],
				label: "heading"),
			action: nil
		)
	}
	// swiftlint: enable function_body_length
	
	static let healthCategory = SharedHealthCategories.Category(
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
