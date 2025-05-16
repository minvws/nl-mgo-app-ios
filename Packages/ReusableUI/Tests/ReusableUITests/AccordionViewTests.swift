/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import SwiftUI
import MGOTest

final class AccordionViewTests: XCTestCase {

	func test_content_hidden() throws {
		
		// Given
		let text = Text("AccordionViewTests")
		
		// When
		let sut = AccordionView(title: "test_content_hidden", startOpen: false) { text }
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
	
	func test_content_open() throws {
		
		// Given
		let text = Text("AccordionViewTests")
		
		// When
		let sut = AccordionView(title: "test_content_open", startOpen: true) { text }
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
}
