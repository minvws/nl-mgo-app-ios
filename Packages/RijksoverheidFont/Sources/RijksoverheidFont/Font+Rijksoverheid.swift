/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

extension Font {
	
	/// Name space for Rijksoverheid font
	public struct RijksoverheidSansWebText {
		
		/// Returns a relative-size font of the specified style.
		///
		/// - Parameters:
		///   - style: The style of the RijksoverheidSansWebTextFont (bold, italic, regular)
		///   - textStyle: the text style
		/// - Returns: the appropriate relative font
		public static func relative(
			_ style: RijksoverheidSansWebTextFont,
			relativeTo textStyle: Font.TextStyle
		) -> Font {
			return Font.custom(
				style.fontName,
				size: textStyle.pointSize,
				relativeTo: textStyle
			)
		}
	}
}
