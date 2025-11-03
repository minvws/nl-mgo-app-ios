/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import RijksoverheidFont
import SwiftUI
import Theme

public struct LinkButtonStyle: ButtonStyle {
	
	/// The Theme
	@Environment(\.theme) private var theme
	
	/// The Alignment
	private var alignment: Alignment
	
	/// Initlializer
	public init(_ alignment: Alignment = .topLeading) {
		
		self.alignment = alignment
	}
	
	/// Style the button to a primary button
	/// - Parameter configuration: the button configuration
	/// - Returns: primary button
	public func makeBody(configuration: Self.Configuration) -> some View {
		
		configuration.label
			.frame(maxWidth: .infinity, alignment: alignment)
			.typography(.bodyMedium, isBold: true)
			.foregroundColor(configuration.isPressed ? theme.actions.tertiary.hover : theme.actions.tertiary.text)
	}
}
