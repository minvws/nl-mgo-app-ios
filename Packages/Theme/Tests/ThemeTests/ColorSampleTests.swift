/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import Theme
import SwiftUI
import MGOTest

final class ColorSampleTests: XCTestCase {
	
	func test_colorSample_lightMode() {
		
		// Given
		let sut = ColorSampleView()
		
		// When
		let content = sut.frame(width: 520, height: 2000)
		
		// Then
		assertSnapshot(of: UIHostingController(rootView: content.colorScheme(.light)), as: .image(precision: 0.95))
	}
	
	func test_colorSample_darkMode() {
		
		// Given
		let sut = ColorSampleView()
		
		// When
		let content = sut.frame(width: 520, height: 2000)
		
		// Then
		assertSnapshot(of: UIHostingController(rootView: content.colorScheme(.dark)), as: .image(precision: 0.95))
	}
}
