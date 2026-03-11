/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// A `ButtonStyle` that broadcasts the button's press state to ancestor views via
/// `PressedPreferenceKey`, allowing them to react to press events without holding the
/// button's state themselves.
///
/// The style applies no visual changes of its own — styling is left entirely to the consumer.
/// Pair this with `.onPreferenceChange(PressedPreferenceKey.self)` on a parent view to
/// receive press-state updates.
struct PressReportingButtonStyle: ButtonStyle {

	/// A binding that will be kept in sync with the button's current press state.
	@Binding var isPressed: Bool

	/// Wraps the button label and publishes `configuration.isPressed` upward via a preference.
	func makeBody(configuration: ButtonStyleConfiguration) -> some View {
		configuration.label
			.preference(key: PressedPreferenceKey.self, value: configuration.isPressed)
	}
}

/// A `PreferenceKey` that carries a button's press state (`Bool`) up the view hierarchy.
///
/// Used by `PressReportingButtonStyle` so that ancestor views — such as a list row — can
/// react to a button press without the button needing a direct binding to those views.
struct PressedPreferenceKey: PreferenceKey {

	/// Default value when no child has set a preference.
	static let defaultValue = false

	/// The last child value wins; a pressed child always overrides an unpressed one.
	static func reduce(value: inout Bool, nextValue: () -> Bool) { value = nextValue() }
}
