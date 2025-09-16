/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import RijksoverheidFont
import SwiftUI
import Theme

public struct HalfOpacityWhenPressedButtonStyle: ButtonStyle {
	
	/// Initlializer
	public init() { /* Public initializer needed for public access */ }
	
	/// Style the button to a primary button
	/// - Parameter configuration: the button configuration
	/// - Returns: primary button
	public func makeBody(configuration: Self.Configuration) -> some View {
		
		configuration.label
			.opacity(configuration.isPressed ? 0.5 : 1)
	}
}
