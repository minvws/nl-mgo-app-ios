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
			.frame(
				maxWidth: .infinity,
				minHeight: ViewTraits.Button.minimumHeight,
				alignment: .center
			)
			.font(
				.RijksoverheidSansWebText
					.relative(
						RijksoverheidFont.regular,
						relativeTo: Font.TextStyle.title
					)
			)
			.foregroundStyle(isEnabled ? theme.labels.primary : theme.symbols.secondary)
			.background(configuration.isPressed ? theme.backgrounds.tertiary : theme.backgrounds.secondary)
			.cornerRadius(ViewTraits.Button.cornerRadius)
			.shadow(color: theme.separators.primary, radius: 0, x: 0, y: 0.5)
	}
}
