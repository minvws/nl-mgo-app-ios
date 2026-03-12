/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import RijksoverheidFont
import SwiftUI
import Theme

public struct ToolbarButtonStyle: ButtonStyle {
	
	/// The Theme
	@Environment(\.mgoTheme) private var theme
	
	/// Initlializer
	public init() { /* Public initializer needed for public access */ }
	
	/// Style the button to a clear button
	/// - Parameter configuration: the button configuration
	/// - Returns: clear button
	public func makeBody(configuration: Self.Configuration) -> some View {
		
		configuration.label
			.typography(.bodyMedium, with: .bold)
			.opacity(configuration.isPressed ? 0.5 : 1.0)
			.foregroundColor(configuration.isPressed ? theme.actions.ghost.hover : theme.actions.ghost.text)
	}
}
