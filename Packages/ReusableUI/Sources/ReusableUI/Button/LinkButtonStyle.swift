/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import RijksoverheidFont
import SwiftUI
import Theme

public struct LinkButtonStyle: ButtonStyle {
		
	/// The Theme
	@Environment(\.theme) private var theme
	
	/// Initializer
	public init() {}

	/// Style the button to a primary button
	/// - Parameter configuration: the button configuration
	/// - Returns: primary button
	public func makeBody(configuration: Self.Configuration) -> some View {
		
		configuration.label
			.frame(maxWidth: .infinity, alignment: .topLeading)
			.rijksoverheidStyle(font: .bold, style: .body)
			.foregroundColor(configuration.isPressed ? theme.actionTertiary.opacity(0.75) : theme.actionTertiary)
	}
}
