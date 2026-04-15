/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
@testable import MGO
import OrganizationSearch

// swiftlint:disable type_body_length
class Generator {
	
	/// Create a mock organization for search results
	/// - Parameters:
	///   - id: the identifier of the organization
	///   - displayName: the display name of the organization
	///   - city: the city of the organization
	///   - address: the address line of the organization
	///   - postalCode: the postal code of the organization
	///   - careTypeDisplay: the care type display name
	///   - dataServices: optional data services array
	/// - Returns: an organization search organization
	static func searchOrganization(
		id: String = "test-id",
		displayName: String = "Test Organization",
		city: String = "Amsterdam",
		address: String = "Test Street 123",
		postalCode: String = "1234AB",
		careTypeDisplay: String = "Hospital",
		dataServices: [OrganizationSearch.DataService]? = nil
	) -> OrganizationSearch.Organization {
		return OrganizationSearch.Organization(
			address: OrganizationSearch.OrganizationAddress(
				address,
				city,
				postalCode
			),
			careType: careTypeDisplay,
			dataServices: dataServices,
			id: id,
			name: displayName
		)
	}
	
	/// Create a healthcare organization
	/// - Parameters:
	///   - id: the identifier of the organization
	///   - name: the name of the organization
	///   - city: the city of the organization
	///   - address: the address of the organization
	///   - postalCode: the postal code of the organization
	///   - useDataService: should we include a data service?
	///   - serviceId: the id for the data service
	/// - Returns: a healthcare organization
	static func healthcareOrganization(
		_ id: String,
		name: String = "Tandarts Tandje Erbij",
		city: String = "Roermond",
		address: String = "Boorplatform 5",
		postalCode: String = "1234AB",
		useDataService: Bool = true,
		serviceId: String = "48"
	) -> OrganizationSearch.Organization {

		var dataServicesArray: [OrganizationSearch.DataService]?
		if useDataService {
			dataServicesArray = [
				OrganizationSearch.DataService(
					id: serviceId,
					authEndpoint: "https://medmij-inlog.vzvz.nl/2.0.0/oauth2/authorize",
					resourceEndpoint: "https://dva-mock.test.mgo.prolocation.net/48",
					tokenEndpoint: "https://medmij-inlog.vzvz.nl/2.0.0/oauth2/token"
				)
			]
		}

		return OrganizationSearch.Organization(
			address: OrganizationSearch.OrganizationAddress(
				address,
				city,
				postalCode
			),
			careType: "Tandarts",
			dataServices: dataServicesArray,
			id: id,
			name: name
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

	/// Return a dummy health sub category where the last schema group is excluded from print
	static func healthCategoryBlockWithLastGroupExcluded() -> HealthCategoryBlock {
		let row = healthCategoryRow()
		let children = row.schema.children
		guard let last = children.last else { return HealthCategoryBlock(heading: row.heading, rows: []) }
		let excluded = HealthUIGroup(
			children: last.children,
			excludeFromPrint: true,
			id: last.id,
			label: last.label
		)
		let modified = children.dropLast() + [excluded]
		let schema = row.schema.with(children: Array(modified))
		let modifiedRow = HealthCategoryRow(
			heading: row.heading,
			subHeading: row.subHeading,
			schema: schema,
			details: row.details,
			action: nil
		)
		return HealthCategoryBlock(heading: "heading subcategory (excluded)", rows: [modifiedRow])
	}
	
	/// Create a dummy health category row
	static func healthCategoryRow() -> HealthCategoryRow {
		
		return HealthCategoryRow(
			heading: "heading",
			subHeading: "healthcare organization",
			schema: Self.healthUISchema(),
			details: "details",
			action: nil
		)
	}
	
	// swiftlint: disable function_body_length
	/// Create a mock health UI Schema
	static func healthUISchema() -> HealthUISchema {
			HealthUISchema(
				children: [
					// Schema Group 1
					HealthUIGroup(
						children: [
							UIElement(
								id: "label_single_value",
								label: "label single value",
								type: .singleValue,
								value: UIElementValue.displayValue(
									DisplayValue(
										code: nil,
										display: "single value",
										system: nil
									)
								),
								display: nil,
								reference: nil,
								url: nil
							),
							UIElement(
								id: "label_reference_value",
								label: "label reference value",
								type: .referenceValue,
								value: nil,
								display: nil,
								reference: "reference",
								url: nil
							),
							UIElement(
								id: "label_reference_value_display",
								label: "label reference value display",
								type: .referenceValue,
								value: UIElementValue.displayValue(
									DisplayValue(
										code: nil,
										display: "single value",
										system: nil
									)
								),
								display: nil,
								reference: "reference",
								url: nil
							),
							UIElement(
								id: "label_reference_link",
								label: "label reference link",
								type: .referenceLink,
								value: nil,
								display: nil,
								reference: "reference",
								url: "Ref/123"
							),
							UIElement(
								id: "label_download_link",
								label: "label download link",
								type: .downloadLink,
								value: nil,
								display: nil,
								reference: nil,
								url: "https://www.apple.com"
							),
							UIElement(
								id: "label_download_reference",
								label: "label download reference",
								type: .downloadBinary,
								value: nil,
								display: nil,
								reference: "reference",
								url: nil
							)
						],
						excludeFromPrint: false,
						id: "section_header_first_group",
						label: "Section Header first group"
					),
					// Schema Group 2
					HealthUIGroup(
						children: [
							UIElement(
								id: "label_single_value_nil",
								label: "label single value nil",
								type: .singleValue,
								value: nil,
								display: nil,
								reference: nil,
								url: nil
							),
							UIElement(
								id: "label_multiple_group_value",
								label: "label multiple group value",
								type: .multipleGroupedValues,
								value:
										.unionArray(
											[
												.displayValueArray(
													[
														DisplayValue(
															code: nil,
															display: "five",
															system: nil
														),
														DisplayValue(
															code: nil,
															display: "six",
															system: nil
														)
													]
												)
											]
										),
								display: nil,
								reference: nil,
								url: nil
							),
							UIElement(
								id: "label_multiple_value",
								label: "label multiple value",
								type: .multipleValues,
								value:
										.unionArray(
											[
												.displayValue(
													DisplayValue(
														code: nil,
														display: "one",
														system: nil
													)
												),
												.displayValue(
													DisplayValue(
														code: nil,
														display: "two",
														system: nil
													)
												)
											]
										),
								display: nil,
								reference: nil,
								url: nil
							),
							UIElement(
								id: "label_multiple_value",
								label: "label multiple value",
								type: .multipleValues,
								value:
										.unionArray(
											[
												.displayValue(
													DisplayValue(
														code: nil,
														display: "one",
														system: nil
													)
												)
											]
										),
								display: nil,
								reference: nil,
								url: nil
							)
						],
						excludeFromPrint: false,
						id: "section_header_second_group",
						label: "Section Header second group"
					),
					// Schema Group 3
					HealthUIGroup(
						children: [
							UIElement(
								id: "label_single_value_display_coding",
								label: "label single value display coding",
								type: .singleValue,
								value: UIElementValue.displayValue(
									DisplayValue(
										code: "code",
										display: "display",
										system: "system"
									)
								),
								display: nil,
								reference: nil,
								url: nil
							),
							UIElement(
								id: "label_multi_value_display_coding",
								label: "label multi value display coding",
								type: .multipleValues,
								value: .unionArray(
									[
										ValueElement.displayValue(
											DisplayValue(
												code: "code",
												display: "display",
												system: "system"
											)
										)
									]
								),
								display: nil,
								reference: nil,
								url: nil
							),
							UIElement(
								id: "label_grouped_value_display_coding",
								label: "label grouped values display coding",
								type: .multipleGroupedValues,
								value: .unionArray(
									[
										ValueElement.displayValueArray(
											[
												DisplayValue(
													code: "code",
													display: "display",
													system: "system"
												)
											]
										)
									]
								),
								display: nil,
								reference: nil,
								url: nil
							)
						],
						excludeFromPrint: false,
						id: "section_header_third_group",
						label: "Section Header third group"
					)
				],
				label: "UI Schema"
			)
		}
		
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
	// swiftlint: enable function_body_length
}
// swiftlint:enable type_body_length
