/*
 * Copyright (c) 2023 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
		modifier(RijksoverheidViewModifier(font: font, style: style))
	}
}
