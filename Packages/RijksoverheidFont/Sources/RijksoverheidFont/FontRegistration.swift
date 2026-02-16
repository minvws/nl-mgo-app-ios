/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import UIKit
import CoreGraphics
import CoreText

/// Errors that can be thrown during font registration.
public enum FontError: Swift.Error {
	/// The font file could not be located in the bundle, parsed as a `CGFont`,
	/// or registered with Core Text.
	case failedToRegisterFont
}

// Approach adapted from:
// https://github.com/pointfreeco/isowords/blob/main/Sources/Styleguide/RegisterFonts.swift
//
// Fonts bundled inside a Swift package are not registered automatically by the
// system, so we must register them manually with Core Text before use.
extension UIFont {
	
	/// Tracks font filenames that have already been registered to prevent
	/// redundant calls to `CTFontManagerRegisterGraphicsFont`.
	@MainActor private static var registeredFonts: Set<String> = []
	
	/// Registers a font file from a bundle with Core Text, making it available
	/// to both UIKit and SwiftUI.
	///
	/// Registration is idempotent: if `fontName` has already been registered
	/// during this process lifetime the call returns immediately without error.
	///
	/// - Parameters:
	///   - bundle: The `Bundle` that contains the font resource.
	///   - fontName: The base filename of the font (without extension).
	///   - fontExtension: The file extension of the font resource.  Defaults
	///                    to `"ttf"`.
	/// - Throws: ``FontError/failedToRegisterFont`` if the resource cannot be
	///           found in the bundle or if Core Text rejects the registration.
	@MainActor static func registerFont(
		bundle: Bundle,
		fontName: String,
		fontExtension: String = "ttf"
	) throws {
		// Skip if already registered
		if registeredFonts.contains(fontName) {
			return
		}
		
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
		
		// Mark as registered
		registeredFonts.insert(fontName)
	}
}
