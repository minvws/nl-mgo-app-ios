/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

extension PreviewContent {

	static let uiSchema = HealthUISchema(
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
						id: "label_multiple_value_display_coding",
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
						id: "label_grouped_values_display_coding",
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
				id: "section_header_third_group",
				label: "Section Header third group"
			)
		],
		label: "UI Schema"
	)
}
