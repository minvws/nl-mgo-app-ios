/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

extension View {
	
	/// Style with the Rijksoverheid font
	/// - Parameters:
	///   - font: The type of font [bold, regular, italic]
	///   - style: The text style [title, body, footnote etc]
	/// - Returns: Styled modifier
	@available(*, deprecated, renamed: "View.typography(_:)", message: "Use the new typography modifier")
	public func rijksoverheidStyle(
		font: RijksoverheidSansWebTextFont,
		style: Font.TextStyle
	) -> some View {
		modifier(RijksoverheidViewModifier(font: font, style: style, pointSize: nil))
	}
}
