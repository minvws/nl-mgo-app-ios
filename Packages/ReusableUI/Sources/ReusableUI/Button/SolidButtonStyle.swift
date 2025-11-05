/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import RijksoverheidFont
import SwiftUI
import Theme

struct SolidButtonStyle: ButtonStyle {
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum ButtonTitle {
			static let insets = EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
		}
		enum Button {
			static let cornerRadius: CGFloat = 12
			static let minimumHeight: CGFloat = 50
			static let opacity: Double = 0.75
		}
	}
	
	/// Style the button to a primary button
	/// - Parameter configuration: the button configuration
	/// - Returns: primary button
	func makeBody(configuration: Self.Configuration) -> some View {
		
		configuration.label
			.typography(.bodyMedium, isBold: true)
			.foregroundColor(theme.actions.solid.text.opacity(configuration.isPressed ? ViewTraits.Button.opacity : 1))
			.tint(theme.actions.solid.text)
			.padding(ViewTraits.ButtonTitle.insets)
			.frame(maxWidth: .infinity, minHeight: ViewTraits.Button.minimumHeight, alignment: .center)
			.background(theme.actions.solid.background.opacity(configuration.isPressed ? ViewTraits.Button.opacity : 1))
			.cornerRadius(ViewTraits.Button.cornerRadius)
	}
}
