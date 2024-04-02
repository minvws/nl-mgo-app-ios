/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct KeyboardButtonStyle: ButtonStyle {

	/// Color scheme (light, dark)
	@Environment(\.colorScheme) var colorScheme
	
	/// Is the button enabled?
	@Environment(\.isEnabled) private var isEnabled: Bool
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Button {
			static let minimumHeight: CGFloat = 44
		}
		enum Circle {
			static let size: CGFloat = 50
		}
	}
	
	/// Style the button to a primary button
	/// - Parameter configuration: the button configuration
	/// - Returns: primary button
	func makeBody(configuration: Self.Configuration) -> some View {
		
		configuration.label
			.frame(maxWidth: .infinity, minHeight: ViewTraits.Button.minimumHeight)
			.rijksoverheidStyle(font: .regular, style: .title)
			.foregroundStyle(isEnabled ? Color.Styleguide.black : Color.Styleguide.Grey.grey5)
			.background {
				if configuration.isPressed {
					// Show a grey circle as a visual confirmation of touch
					Circle()
						.foregroundStyle(colorScheme == .light ? Color.Styleguide.Grey.grey2 : Color.Styleguide.Grey.grey8)
						.frame(width: ViewTraits.Circle.size, height: ViewTraits.Circle.size)
				}
			}
	}
}
