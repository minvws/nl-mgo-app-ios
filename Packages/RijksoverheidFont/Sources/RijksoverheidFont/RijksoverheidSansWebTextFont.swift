/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct RijksoverheidSansWebTextFont {
	
	/// The name of the font
	public let fontName: String
	
	/// The name of the font file
	public let fileName: String
	
	/// Create a Rijksoverheid font
	/// - Parameters:
	///   - file: the name of the font file (without extension)
	///   - font: the name of the font in the font file
	internal init(file: String, font: String) {
		
		self.fileName = file
		self.fontName = font
		
		do {
			try UIFont.registerFont(bundle: .module, fontName: file)
		} catch {
			let reason = error.localizedDescription
			fatalError("Failed to register font \(fontName) (file: \(fileName)): \(reason)")
		}
	}
	
	/// The bold Rijksoverheid font
	@MainActor public static let bold = RijksoverheidSansWebTextFont(
		file: "ROsanswebtextbold",
		font: "RijksoverheidSansWebText-Bold"
	)
	
	/// The italic Rijksoverheid font
	@MainActor public static let italic = RijksoverheidSansWebTextFont(
		file: "ROsanswebtextitalic",
		font: "RijksoverheidSansWebText-Italic"
	)
	
	/// The regular Rijksoverheid font
	@MainActor public static let regular = RijksoverheidSansWebTextFont(
		file: "ROsanswebtextregular",
		font: "RijksoverheidSansWebText-Regular"
	)
}
