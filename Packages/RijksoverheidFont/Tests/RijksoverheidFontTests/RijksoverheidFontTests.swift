/*
 * Copyright (c) 2023 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest
@testable import RijksoverheidFont
import Nimble
import SnapshotTesting
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
					.foregroundStyle(.black)
					.frame(width: 100, height: 50)
	
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
					.foregroundStyle(.black)
					.frame(width: 100, height: 50)
				
				// Then
				assertSnapshot(of: content, as: .image)
			}
		}
	}
}
