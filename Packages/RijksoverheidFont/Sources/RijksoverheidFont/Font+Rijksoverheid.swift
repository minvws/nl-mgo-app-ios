/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

extension Font {
	
	public struct RijksoverheidSansWebText {
		
		/// Returns a fixed-size font of the specified style.
		/// - Parameters:
		///   - style: The style of the RijksoverheidSansWebTextFont (bold, italic, regular)
		///   - size: The fixed font size
		/// - Returns: Fixed font
		public static func fixed(_ style: RijksoverheidSansWebTextFont, size: CGFloat) -> Font {
			return Font.custom(style.fontName, fixedSize: size)
		}
		
		/// Returns a relative-size font of the specified style.
		///
		/// - Parameters:
		///   - style: The style of the RijksoverheidSansWebTextFont (bold, italic, regular)
		///   - size: the relative font size
		///   - textStyle: the text style
		/// - Returns: the approptiate relative font
		public static func relative(_ style: RijksoverheidSansWebTextFont, size: CGFloat, relativeTo textStyle: Font.TextStyle) -> Font {
			return Font.custom(style.fontName, size: size, relativeTo: textStyle)
		}
	}
}
