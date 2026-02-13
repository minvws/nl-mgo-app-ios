/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import UIKit

extension UIFont {
	
	/// Creates a `UIFont` for the given Rijksoverheid font variant, applying
	/// the variable-font `wght` axis when a weight is specified.
	///
	/// SwiftUI's `Font.custom` API does not expose variable-font axis values,
	/// so this method constructs the font via `UIFontDescriptor` instead.  The
	/// resulting `UIFont` can then be bridged to a SwiftUI `Font` using
	/// `Font(_ uiFont: CTFont)`.
	///
	/// - Parameters:
	///   - style: The ``RijksoverheidFont`` variant that describes the font
	///            file and desired weight.
	///   - size: The desired font size in points.
	/// - Returns: A `UIFont` with the PostScript name and, if applicable, the
	///            `wght` axis value from `style.weight` applied.
	public static func rijksoverheidFont(
		_ style: RijksoverheidFont,
		size: CGFloat
	) -> UIFont {
		let fontDescriptor = UIFontDescriptor(
			fontAttributes: [
				.name: style.fontName,
				.size: size
			]
		)
		
		// Apply the wght axis variation when a weight is provided.
		// 2003265652 is the four-character tag 'wght' interpreted as a UInt32.
		if let weight = style.weight {
			let variationDescriptor = fontDescriptor.addingAttributes(
				[
					UIFontDescriptor.AttributeName(rawValue: "NSCTFontVariationAttribute"): [
						2003265652: weight
					]
				]
			)
			return UIFont(descriptor: variationDescriptor, size: size)
		}
		
		return UIFont(descriptor: fontDescriptor, size: size)
	}
}
