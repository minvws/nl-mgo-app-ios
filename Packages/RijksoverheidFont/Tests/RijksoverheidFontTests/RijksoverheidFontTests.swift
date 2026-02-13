/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import RijksoverheidFont
import MGOTest
import SwiftUI

@MainActor
final class RijksoverheidFontTests: XCTestCase {
	
	func test_typography() {
		
		let styles: [Typography] = Typography.allCases
		
		for style in styles {
			
			// When
			let content = Text("Testing")
				.typography(style)
				.foregroundColor(.black)
				.frame(width: 120, height: 50)
			
			// Then
			assertSnapshot(of: content, as: .image)
		}
	}
	
	func test_typography_bold() {
		
		let styles: [Typography] = Typography.allCases
		
		for style in styles {
			
			// When
			let content = Text("Testing")
				.typography(style, with: .bold)
				.foregroundColor(.black)
				.frame(width: 120, height: 50)
			
			// Then
			assertSnapshot(of: content, as: .image)
		}
	}
	
	func test_typography_semibold() {
		
		let styles: [Typography] = Typography.allCases
		
		for style in styles {
			
			// When
			let content = Text("Testing")
				.typography(style, with: .semiBold)
				.foregroundColor(.black)
				.frame(width: 120, height: 50)
			
			// Then
			assertSnapshot(of: content, as: .image)
		}
	}
	
	func test_typography_italic() {
		
		let styles: [Typography] = Typography.allCases
		
		for style in styles {
			
			// When
			let content = Text("Testing")
				.typography(style, with: .italic)
				.foregroundColor(.black)
				.frame(width: 120, height: 50)
			
			// Then
			assertSnapshot(of: content, as: .image)
		}
	}
}
