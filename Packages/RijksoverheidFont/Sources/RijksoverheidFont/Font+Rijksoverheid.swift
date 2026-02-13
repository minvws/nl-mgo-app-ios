/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI
import UIKit

extension Font {
	
	/// Namespace for constructing SwiftUI `Font` values from Rijksoverheid font variants.
	///
	/// Use ``relative(_:relativeTo:)`` when you need a `Font` that scales with
	/// Dynamic Type.  In practice, the ``View/typography(_:with:)`` modifier
	/// calls this for you, so direct use is rarely necessary.
	public struct RijksoverheidSansWebText {
		
		/// Returns a `Font` that scales relative to the given `Font.TextStyle`.
		///
		/// For variable font variants (those with a non-nil ``RijksoverheidFont/weight``),
		/// the font is constructed via UIKit so the `wght` axis value can be
		/// applied before handing it to SwiftUI.  Static variants fall back to
		/// `Font.custom(_:size:relativeTo:)`.
		///
		/// - Parameters:
		///   - style: The ``RijksoverheidFont`` variant to use (e.g. `.bold`, `.italic`).
		///   - textStyle: The `Font.TextStyle` the returned font should scale relative to.
		/// - Returns: A `Font` with the correct typeface and Dynamic Type scaling.
		public static func relative(
			_ style: RijksoverheidFont,
			relativeTo textStyle: Font.TextStyle
		) -> Font {
			// Variable font: build via UIKit so the wght axis value is applied.
			if let _ = style.weight {
				let uiFont = UIFont.rijksoverheidFont(style, size: textStyle.pointSize)
				return Font(uiFont as CTFont)
			}
			
			// Static font: use the standard SwiftUI custom-font API.
			return Font.custom(
				style.fontName,
				size: textStyle.pointSize,
				relativeTo: textStyle
			)
		}
	}
}
