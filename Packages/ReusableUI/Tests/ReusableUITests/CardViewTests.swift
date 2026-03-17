/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import SwiftUI
import Testing
import SnapshotTesting

@MainActor
struct CardViewTests {
	
	@Test("snapshot of a card")
	func card() {
		
		// Given
		let sut = CardView(
			title: "heading",
			message: "subheading",
			details: "meta",
			config: CardViewConfig(
				showChevron: false,
				titleColor: Theme().labels.primary
			)
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
	
	@Test("snapshot of a card with chevron")
	func chevron() {
		
		// Given
		let sut = CardView(
			title: "heading",
			message: "subheading",
			details: "meta",
			config: CardViewConfig(
				showChevron: true,
				titleColor: Theme().labels.primary
			)
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
	
	@Test("snapshot of a card with a secondary color Title")
	func secondaryColor() {
		
		// Given
		let sut = CardView(
			title: "heading",
			message: "subheading",
			details: "meta",
			config: CardViewConfig(
				showChevron: true,
				titleColor: Theme().labels.secondary
			)
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
	
	@Test("snapshot of a card with long texts")
	func long() {
		
		// Given
		let sut = CardView(
			title: "This is a long heading that should wrap and fit within the card",
			message: "And this is a long subheading to test the layout",
			details: "this is meta",
			config: CardViewConfig(titleColor: Theme().labels.primary)
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
	
	@Test("snapshot of a card with only a heading")
	func headingOnly() {
		
		// Given
		let sut = CardView(
			title: "This is a long heading that should wrap and fit within the card",
			message: nil,
			details: nil,
			config: CardViewConfig(titleColor: Theme().labels.primary)
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
