/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

struct HealthCategoryBlockRowView: View {

	/// The Theme
	@Environment(\.mgoTheme) var theme

	/// The row to display
	let element: HealthCategoryRow

	/// The accessibility identifier for this row
	let accessibilityIdentifier: String
	
	/// Tracks whether the button is currently pressed, driven by `PressedPreferenceKey`.
	@State private var isPressed = false

	var body: some View {

		Button {
			element.action?()
		} label: {
			CardView(
				title: element.heading,
				message: element.subHeading,
				details: element.details,
				config: CardViewConfig(
					showChevron: true,
					titleColor: theme.labels.primary
				)
			)
			.contentShape(Rectangle())
		}
		.accessibilityIdentifier(accessibilityIdentifier)
		.accessibilityRemoveTraits(.isHeader)
		.buttonStyle(PressReportingButtonStyle(isPressed: $isPressed))
		.onPreferenceChange(PressedPreferenceKey.self) { isPressed = $0 }
		.listRowBackground(isPressed ? theme.backgrounds.tertiary : theme.backgrounds.secondary)
	}
}
