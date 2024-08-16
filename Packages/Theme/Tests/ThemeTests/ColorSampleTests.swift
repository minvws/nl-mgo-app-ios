/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
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
		let content = sut.frame(width: 520, height: 1950)
		
		// Then
		assertSnapshot(of: UIHostingController(rootView: content.colorScheme(.light)), as: .image(precision: 0.95))
	}
	
	func test_colorSample_darkMode() {
		
		// Given
		let sut = ColorSampleView()
		
		// When
		let content = sut.frame(width: 520, height: 1950)
		
		// Then
		assertSnapshot(of: UIHostingController(rootView: content.colorScheme(.dark)), as: .image(precision: 0.95))
	}
}
