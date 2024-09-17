/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

class HealthCategoryRowViewTests: XCTestCase {
	
	func test_empty() {
		
		// Given
		let sut = HealthCategoryRowView(block: CategoryButton(id: 1, title: "Medicijnen", state: .empty, box: 1))
		
		// When
		let view = sut.frame(width: 380, height: 200)
		
		// Then
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.light)), as: .image)
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.dark)), as: .image)
	}
	
	func test_loading() {
		
		// Given
		let sut = HealthCategoryRowView(block: CategoryButton(id: 1, title: "Medicijnen", state: .loading, box: 1))
		
		// When
		let view = sut.frame(width: 380, height: 200)
		
		// Then
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.light)), as: .image)
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.dark)), as: .image)
	}
	
	func test_loaded() {
		
		// Given
		let sut = HealthCategoryRowView(block: CategoryButton(id: 1, title: "Medicijnen", state: .loaded, box: 1))
		
		// When
		let view = sut.frame(width: 380, height: 200)
		
		// Then
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.light)), as: .image(precision: 0.95))
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.dark)), as: .image(precision: 0.95))
	}
}
