/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

class FavoriteCategoryRowViewTests: XCTestCase {
	
	@MainActor func test_empty() {
		
		// Given
		let sut = FavoriteRowView(
			category: Generator.healthCategory,
			state: .empty
		)
		
		// When
		let view = sut.frame(width: 380, height: 200)
		
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
	
	@MainActor func test_loading() {
		
		// Given
		let sut = FavoriteRowView(
			category: Generator.healthCategory,
			state: .loading
		)
		
		// When
		let view = sut.frame(width: 380, height: 200)
		
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
	
	@MainActor func test_loaded() {
		
		// Given
		let sut = FavoriteRowView(
			category: Generator.healthCategory,
			state: .loaded
		)
		
		// When
		let view = sut.frame(width: 380, height: 200)
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: view.colorScheme(.light)),
			as: .image(precision: 0.95)
		)
		assertSnapshot(
			of: UIHostingController(rootView: view.colorScheme(.dark)),
			as: .image(precision: 0.95)
		)
	}
}
