/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

extension PreviewContent {

	static let uiSchema = UISchema(
		children: [
			// Schema Group 1
			UISchemaGroup(
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
						url: "Ref/123"
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
					)
				],
				label: "Section Header first group"
			),
			// Schema Group 2
			UISchemaGroup(
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
							DisplayElement.stringArray(["one", "two"]),
							DisplayElement.stringArray(["three", "four"])
						]),
						label: "label multiple group value",
						type: .multipleGroupedValues,
						reference: nil,
						url: nil
					),
					UIElement(
						display: UIElementDisplay.unionArray([DisplayElement.stringArray(["one", "two"])]),
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
					)
				],
				label: "Section Header second group")
		],
		label: "UI Schema"
	)
}
