/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct SectionButtonStyle: ButtonStyle {
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Button {
			static let minimumHeight: CGFloat = 22
		}
	}
	
	/// Style the button to a destructive button
	/// - Parameter configuration: the button configuration
	/// - Returns: destructive button
	func makeBody(configuration: Self.Configuration) -> some View {
		
		configuration.label
			.typography(.bodyMedium, with: .bold)
			.foregroundColor(configuration.isPressed ? theme.actions.ghost.hover : theme.actions.ghost.text)
			.frame(minHeight: ViewTraits.Button.minimumHeight, alignment: .center)
			.background(Color.clear)
	}
}
