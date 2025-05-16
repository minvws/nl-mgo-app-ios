/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import SwiftUI
import MGOTest

final class ImageContentViewTests: XCTestCase {

	func test_imageContentView() throws {
		
		// Given
		let sut = ImageContentView(
			icon: Image(systemName: "42.circle"),
			heading: "Heading",
			subHeading: "SubHeading",
			titleStyle: .largeTitle,
			subHeadingForegroundColor: Color.pink
		)
		
		// When
		let view = sut.frame(width: 300, height: 600)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
	
	func test_onRotate() {
		
		// Given
		let sut = ImageContentView(
			icon: Image(systemName: "42.circle"),
			heading: "Heading",
			subHeading: "SubHeading",
			titleStyle: .largeTitle,
			subHeadingForegroundColor: Color.pink
		)
		
		// When
		sut.handleRotation(UIDeviceOrientation.portrait)
		
		// Then
		expect(sut.showImage) == true
	}
}
