/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import RijksoverheidFont
import SwiftUI
import Theme

struct SecondaryButtonStyle: ButtonStyle {
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum ButtonTitle {
			static let insets = EdgeInsets( top: 16, leading: 24, bottom: 16, trailing: 24)
		}
		enum Button {
			static let cornerRadius: CGFloat = 8
			static let minimumHeight: CGFloat = 48
		}
	}
	
	/// Style the button to a primary button
	/// - Parameter configuration: the button configuration
	/// - Returns: primary button
	func makeBody(configuration: Self.Configuration) -> some View {
		
		configuration.label
			.rijksoverheidStyle(font: .bold, style: .body)
			.foregroundColor(theme.actionTertiary)
			.padding(ViewTraits.ButtonTitle.insets)
			.frame(maxWidth: .infinity, minHeight: ViewTraits.Button.minimumHeight, alignment: .center)
			.background(configuration.isPressed ? theme.actionTertiary : theme.actionSecondary)
			.cornerRadius(ViewTraits.Button.cornerRadius)
	}
}
