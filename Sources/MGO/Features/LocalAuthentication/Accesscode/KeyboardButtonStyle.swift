/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
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
			static let minimumHeight: CGFloat = 44
		}
	}
	
	/// Style the button to a primary button
	/// - Parameter configuration: the button configuration
	/// - Returns: primary button
	func makeBody(configuration: Self.Configuration) -> some View {
		
		configuration.label
			.frame(maxWidth: .infinity, minHeight: ViewTraits.Button.minimumHeight, maxHeight: .infinity)
			.rijksoverheidStyle(font: .regular, style: .title)
			.foregroundStyle(isEnabled ? theme.contentPrimary : theme.iconsSecondary)
			.background {
				if configuration.isPressed {
					Circle()
						.foregroundStyle(theme.backgroundTertiary)
				}
			}
	}
}
