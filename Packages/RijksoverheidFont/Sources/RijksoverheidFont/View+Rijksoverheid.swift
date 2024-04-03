/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

extension View {
	
	/// Style with the Rijksoverheid font
	/// - Parameters:
	///   - font: The type of font [bold, regular, italic]
	///   - style: The text style [title, body, footnote etc]
	/// - Returns: Styled modifier
	public func rijksoverheidStyle(font: RijksoverheidSansWebTextFont, style: Font.TextStyle) -> some View {
		modifier(RijksoverheidViewModifier(font: font, style: style, pointSize: nil))
	}
	
	/// Style with the Rijksoverheid font
	/// - Parameters:
	///   - font: The type of font [bold, regular, italic]
	///   - style: he text style [title, body, footnote etc]
	///   - pointSize: the point size of the font to use
	/// - Returns: Styled modifier
	public func rijksoverheidStyle(font: RijksoverheidSansWebTextFont, style: Font.TextStyle, pointSize: CGFloat) -> some View {
		modifier(RijksoverheidViewModifier(font: font, style: style, pointSize: pointSize))
	}
}
