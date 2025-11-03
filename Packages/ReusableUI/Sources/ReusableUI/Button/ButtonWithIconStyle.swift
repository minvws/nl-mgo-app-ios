/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import RijksoverheidFont
import SwiftUI
import Theme

struct ButtonWithIconStyle: ButtonStyle {
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum ButtonTitle {
			static let insets = EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
		}
		enum Button {
			static let minimumHeight: CGFloat = 50
		}
	}
	
	/// Style the button to a button with icon style
	/// - Parameter configuration: the button configuration
	/// - Returns: button with icon style
	func makeBody(configuration: Self.Configuration) -> some View {
		
		configuration.label
			.typography(.bodyMedium)
			.foregroundColor(theme.actions.tertiary.text)
			.tint(configuration.isPressed ? theme.actions.tertiary.text.opacity(0.50) : theme.actions.tertiary.text)
			.padding(ViewTraits.ButtonTitle.insets)
			.frame(maxWidth: .infinity, minHeight: ViewTraits.Button.minimumHeight, alignment: .center)
			.background(configuration.isPressed ? theme.backgrounds.tertiary : theme.backgrounds.secondary)
	}
}
