/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import RijksoverheidFont
import MGOTest
import SwiftUI

final class RijksoverheidFontTests: XCTestCase {
	
	func testFonts_relative() {
		
		// Given
		let fonts: [RijksoverheidSansWebTextFont] = [
			RijksoverheidSansWebTextFont.bold,
			RijksoverheidSansWebTextFont.italic,
			RijksoverheidSansWebTextFont.regular
		]
		
		for font in fonts {
			for textStyle in Font.TextStyle.allCases {
				
				// When
				let content = Text("Testing")
					.rijksoverheidStyle(font: font, style: textStyle)
					.foregroundColor(.black)
					.frame(width: 120, height: 50)
	
				// Then
				assertSnapshot(of: content, as: .image)
			}
		}
	}
	
	func testFonts_fixedSize() {
		
		// Given
		let fonts: [RijksoverheidSansWebTextFont] = [
			RijksoverheidSansWebTextFont.bold,
			RijksoverheidSansWebTextFont.italic,
			RijksoverheidSansWebTextFont.regular
		]
		
		for font in fonts {
			for textStyle in Font.TextStyle.allCases {
				
				// When
				let content = Text("Testing")
					.font(.RijksoverheidSansWebText.fixed(font, size: textStyle.pointSize))
					.foregroundColor(.black)
					.frame(width: 120, height: 50)
				
				// Then
				assertSnapshot(of: content, as: .image)
			}
		}
	}
}
