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
		label: "UI Schema"
	)
}
