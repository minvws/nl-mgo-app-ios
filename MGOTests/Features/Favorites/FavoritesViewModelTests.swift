/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class FavoritesViewModelTests: XCTestCase {
	
	private var coordinatorSpy: HealthcareCoordinatorSpy!
	private var sut: FavoritesViewModel!
	
	override func setUp() {
		
		super.setUp()
		coordinatorSpy = HealthcareCoordinatorSpy()
	}
	
	@MainActor func createSut() {
		
		sut = FavoritesViewModel(coordinator: coordinatorSpy)
	}
	

	@MainActor func test_reduce_closeButtonPressed() {
		
		// Given
		createSut()
		
		// When
		sut.reduce(.closeButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.closeSheet
	}
	
	@MainActor func test_reduce_saveButtonPressed() {
		
		// Given
		createSut()
		
		// When
		sut.reduce(.saveButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.closeSheet
	}
	
	@MainActor func test_reduce_addButtonPressed() {
		
		// Given
		let category = Generator.healthCategory
		createSut()
		
		// When
		sut.reduce(.addButtonPressed(category))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.sut.state.favorites).to(haveCount(1))
		expect(self.sut.state.favorites.first) == category
	}
	
	@MainActor func test_reduce_removeButtonPressed() {
		
		// Given
		let category = Generator.healthCategory
		createSut()
		sut.state.favorites = [category]
		
		// When
		sut.reduce(.removeButtonPressed(category))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.sut.state.favorites).to(beEmpty())
	}
}
