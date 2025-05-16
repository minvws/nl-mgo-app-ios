/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import RijksoverheidFont
import SwiftUI
import Theme

struct TertiaryButtonStyle: ButtonStyle {
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum ButtonTitle {
			static let insets = EdgeInsets( top: 16, leading: 24, bottom: 16, trailing: 24)
		}
		enum Button {
			static let minimumHeight: CGFloat = 48
		}
	}
	
	/// Style the button to a destructive button
	/// - Parameter configuration: the button configuration
	/// - Returns: destructive button
	func makeBody(configuration: Self.Configuration) -> some View {
		
		configuration.label
			.rijksoverheidStyle(font: .bold, style: .body)
			.foregroundColor(configuration.isPressed ? theme.interactionTertiaryDefaultTextHover : theme.interactionTertiaryDefaultText)
			.padding(ViewTraits.ButtonTitle.insets)
			.frame(maxWidth: .infinity, minHeight: ViewTraits.Button.minimumHeight, alignment: .center)
			.background(Color.clear)
	}
}
