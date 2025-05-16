/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import RijksoverheidFont
import SwiftUI
import Theme

public struct HoverButtonStyle: ButtonStyle {
	
	/// The Theme
	@Environment(\.theme) private var theme
	
	/// Initlializer
	public init() { /* Public initializer needed for public access */ }
	
	/// Style the button to a primary button
	/// - Parameter configuration: the button configuration
	/// - Returns: primary button
	public func makeBody(configuration: Self.Configuration) -> some View {
		
		configuration.label
			.background(configuration.isPressed ? theme.backgroundTertiary : theme.backgroundSecondary)
	}
}
