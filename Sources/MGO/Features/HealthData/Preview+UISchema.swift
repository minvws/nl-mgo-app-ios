/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
	)
}
