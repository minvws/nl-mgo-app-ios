/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct RijksoverheidSansWebTextFont {
	public let fontName: String
	public let fileName: String
	
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
	
	public static let bold = RijksoverheidSansWebTextFont(
		file: "ROsanswebtextbold",
		font: "RijksoverheidSansWebText-Bold"
	)
	public static let italic = RijksoverheidSansWebTextFont(
		file: "ROsanswebtextitalic",
		font: "RijksoverheidSansWebText-Italic"
	)
	public static let regular = RijksoverheidSansWebTextFont(
		file: "ROsanswebtextregular",
		font: "RijksoverheidSansWebText-Regular"
	)
}
