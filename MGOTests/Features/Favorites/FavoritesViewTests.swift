/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class FavoritesViewTests: XCTestCase {
	
	private var coordinatorSpy: HealthcareCoordinatorSpy!
	private var viewModel: FavoritesViewModel!
	private var sut: FavoritesView!
	
	override func setUp() {
		
		super.setUp()
		coordinatorSpy = HealthcareCoordinatorSpy()
	}
	
	@MainActor func createSut() {
		
		viewModel = FavoritesViewModel(coordinator: coordinatorSpy)
		sut = FavoritesView(viewModel: self.viewModel)
	}
	
	@MainActor func test_noFavorites() {
		
		// Given
		createSut()
		viewModel.state.favorites = []
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_favorites() throws {
		
		// Given
		createSut()
		viewModel.state.favorites = [Generator.healthCategory]
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
}
