/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import SwiftUI
import MGOTest

final class CardViewTests: XCTestCase {
	
	func test_card() {
		
		// Given
		let sut = CardView(title: "heading", message: "subheading", meta: "meta")
		
		// When
		let view = sut.frame(width: 400, height: 100)
			.background(Theme().backgrounds.secondary)
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: view.colorScheme(.light)),
			as: .image
		)
		assertSnapshot(
			of: UIHostingController(rootView: view.colorScheme(.dark)),
			as: .image
		)
	}
	
	func test_card_long() {
		
		// Given
		let sut = CardView(
			title: "This is a long heading that should wrap and fit within the card",
			message: "And this is a long subheading to test the layout",
			meta: "this is meta"
		)
		
		// When
		let view = sut.frame(width: 400, height: 100)
			.background(Theme().backgrounds.secondary)
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: view.colorScheme(.light)),
			as: .image
		)
		assertSnapshot(
			of: UIHostingController(rootView: view.colorScheme(.dark)),
			as: .image
		)
	}
	
	func test_card_headingOnly() {
		
		// Given
		let sut = CardView(
			title: "This is a long heading that should wrap and fit within the card",
			message: nil,
			meta: nil
		)
		
		// When
		let view = sut.frame(width: 400, height: 100)
			.background(Theme().backgrounds.secondary)
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: view.colorScheme(.light)),
			as: .image
		)
		assertSnapshot(
			of: UIHostingController(rootView: view.colorScheme(.dark)),
			as: .image
		)
	}
	
}
