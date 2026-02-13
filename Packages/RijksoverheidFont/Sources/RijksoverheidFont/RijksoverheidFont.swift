/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// A descriptor for a Rijksoverheid variable font variant.
///
/// `RijksoverheidFont` wraps the font file name, PostScript name, and optional
/// `wght` axis value needed to instantiate a specific weight from the
/// *RijksSans* variable font files.  The font is automatically registered with
/// Core Text the first time an instance is created.
///
/// Use one of the built-in static variants directly:
///
/// ```swift
/// Text("Welkom")
///     .typography(.headingLarge)                   // uses .bold automatically
///
/// Text("Disclaimer")
///     .typography(.bodySmall, with: .italic)       // explicit italic override
/// ```
public struct RijksoverheidFont {
	
	/// The PostScript name of the font face (used when constructing a `UIFont`).
	public let fontName: String
	
	/// The base filename of the font resource (without the `.ttf` extension).
	public let fileName: String
	
	/// The `wght` axis value applied to the variable font, or `nil` for
	/// non-variable fonts.  The RijksSans variable font supports values
	/// in the range 200–800.
	public let weight: CGFloat?
	
	/// Initialises a font descriptor and registers the underlying font file
	/// with Core Text so it can be used by UIKit and SwiftUI.
	///
	/// - Parameters:
	///   - file: The base filename of the `.ttf` resource (without extension).
	///   - font: The PostScript name embedded in the font file.
	///   - weight: The `wght` axis value for variable fonts.  Pass `nil` for
	///             static fonts.  Defaults to `nil`.
	///
	/// - Note: Registration is skipped if the font file has already been
	///         registered in this process.
	@MainActor internal init(file: String, font: String, weight: CGFloat? = nil) {
		
		self.fileName = file
		self.fontName = font
		self.weight = weight
		
		do {
			try UIFont.registerFont(bundle: .module, fontName: file)
		} catch {
			let reason = error.localizedDescription
			fatalError("Failed to register font \(fontName) (file: \(fileName)): \(reason)")
		}
	}
	
	// MARK: - Built-in variants

	/// Bold variant of the RijksSans variable font (`wght` 700).
	///
	/// Used by default for all ``Typography`` heading styles.
	@MainActor public static let bold = RijksoverheidFont(
		file: "RijksSansVF-Regular",
		font: "RijksSansVF-Regular",
		weight: 700
	)
	
	/// Semi-bold variant of the RijksSans variable font (`wght` 600).
	@MainActor public static let semiBold = RijksoverheidFont(
		file: "RijksSansVF-Regular",
		font: "RijksSansVF-Regular",
		weight: 600
	)
	
	/// Italic variant of the RijksSans variable font (`wght` 400).
	///
	/// Sourced from the separate `RijksSansVF-Italic.ttf` file.
	@MainActor public static let italic = RijksoverheidFont(
		file: "RijksSansVF-Italic",
		font: "RijksSansVF-Italic",
		weight: 400
	)
	
	/// Regular (upright) variant of the RijksSans variable font (`wght` 400).
	///
	/// Used by default for all ``Typography`` body styles.
	@MainActor public static let regular = RijksoverheidFont(
		file: "RijksSansVF-Regular",
		font: "RijksSansVF-Regular",
		weight: 400
	)
}
