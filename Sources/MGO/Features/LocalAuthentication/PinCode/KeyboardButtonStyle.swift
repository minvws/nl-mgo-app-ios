/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import RijksoverheidFont
import SwiftUI
import Theme

struct KeyboardButtonStyle: ButtonStyle {
	
	/// Is the button enabled?
	@Environment(\.isEnabled) private var isEnabled: Bool
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Button {
			static let minimumHeight: CGFloat = 46
			static let cornerRadius: CGFloat = 5
		}
	}
	
	/// Style the button to a primary button
	/// - Parameter configuration: the button configuration
	/// - Returns: primary button
	func makeBody(configuration: Self.Configuration) -> some View {
		
		configuration.label
			.frame(maxWidth: .infinity, minHeight: ViewTraits.Button.minimumHeight, alignment: .center)
			.rijksoverheidStyle(font: .regular, style: .title2)
			.foregroundStyle(isEnabled ? theme.contentPrimary : theme.symbolSecondary)
			.background(configuration.isPressed ? theme.backgroundTertiary : theme.backgroundSecondary)
			.cornerRadius(ViewTraits.Button.cornerRadius)
			.shadow(color: theme.borderPrimary, radius: 0, x: 0, y: 0.5)
	}
}
