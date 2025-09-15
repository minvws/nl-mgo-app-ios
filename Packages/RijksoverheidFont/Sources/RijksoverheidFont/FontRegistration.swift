/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import UIKit
import CoreGraphics
import CoreText

public enum FontError: Swift.Error {
	case failedToRegisterFont
}
/// Taken from https://github.com/pointfreeco/isowords/blob/main/Sources/Styleguide/RegisterFonts.swift
/// Necessary because fonts loaded from a swift package are not automatically registered
extension UIFont {
	
	/// Register a font from a bundle
	/// - Parameters:
	///   - bundle: The bundle containing the font
	///   - fontName: the name of the font file
	///   - fontExtension: the extension of the font file (defaults to ttf)
	static func registerFont(bundle: Bundle, fontName: String, fontExtension: String = "ttf") throws {
		guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
			  let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
			  let font = CGFont(fontDataProvider) else {
			throw FontError.failedToRegisterFont
		}
		
		var error: Unmanaged<CFError>?
		let success = CTFontManagerRegisterGraphicsFont(font, &error)
		guard success else {
			throw FontError.failedToRegisterFont
		}
	}
}
