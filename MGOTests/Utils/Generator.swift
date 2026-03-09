/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
@testable import MGO
import OrganizationSearch

class Generator {
	
	/// Create a mock organization for search results
	/// - Parameters:
	///   - id: the identifier of the organization
	///   - displayName: the display name of the organization
	///   - city: the city of the organization
	///   - addressLine: the address line of the organization
	///   - postalCode: the postal code of the organization
	///   - careTypeDisplay: the care type display name
	///   - dataServices: optional data services dictionary
	/// - Returns: an organization search organization
	static func searchOrganization(
		id: String = "test-id",
		displayName: String = "Test Organization",
		city: String = "Amsterdam",
		addressLine: String = "Test Street 123",
		postalCode: String = "1234AB",
		careTypeDisplay: String = "Hospital",
		dataServices: [String: OrganizationSearch.DataService]? = nil
	) -> OrganizationSearch.Organization {
		return OrganizationSearch.Organization(
			addressLine: addressLine,
			careTypeDisplay: careTypeDisplay,
			city: city,
			dataServices: dataServices,
			displayName: displayName,
			geoLat: nil,
			geoLng: nil,
			id: id,
			postalCode: postalCode,
			searchBlob: nil
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
	///   - withLines: use address as input for the lines part?
	/// - Returns: a healthcare organization
	static func healthcareOrganization(_ id: String, name: String = "Tandarts Tandje Erbij", city: String = "Roermond", address: String = "Boorplatform 5", postalCode: String = "1234AB", useDataService: Bool = true, serviceId: String = "48", withLines: Bool = true) -> OrganizationSearch.Organization {

		var dataServicesDict: [String: OrganizationSearch.DataService]?
		if useDataService {
			dataServicesDict = [
				serviceId: OrganizationSearch.DataService(
					authEndpoint: "https://medmij-inlog.vzvz.nl/2.0.0/oauth2/authorize",
					resourceEndpoint: "https://dva-mock.test.mgo.prolocation.net/48",
					tokenEndpoint: "https://medmij-inlog.vzvz.nl/2.0.0/oauth2/token"
				)
			]
		}

		return OrganizationSearch.Organization(
			addressLine: address,
			careTypeDisplay: "Tandarts",
			city: city,
			dataServices: dataServicesDict,
			displayName: name,
			id: id,
			postalCode: postalCode
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
								label: "label reference value",
								type: .referenceValue,
								value: nil,
								display: nil,
								reference: "reference",
								url: nil
							),
							UIElement(
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
								label: "label reference link",
								type: .referenceLink,
								value: nil,
								display: nil,
								reference: "reference",
								url: "Ref/123"
							),
							UIElement(
								label: "label download link",
								type: .downloadLink,
								value: nil,
								display: nil,
								reference: nil,
								url: "https://www.apple.com"
							),
							UIElement(
								label: "label download reference",
								type: .downloadBinary,
								value: nil,
								display: nil,
								reference: "reference",
								url: nil
							)
						],
						label: "Section Header first group"
					),
					// Schema Group 2
					HealthUIGroup(
						children: [
							UIElement(
								label: "label single value nil",
								type: .singleValue,
								value: nil,
								display: nil,
								reference: nil,
								url: nil
							),
							UIElement(
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
						label: "Section Header second group"
					),
					// Schema Group 3
					HealthUIGroup(
						children: [
							UIElement(
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
						label: "Section Header third group"
					)
				],
				label: "UI Schema"
			),
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
