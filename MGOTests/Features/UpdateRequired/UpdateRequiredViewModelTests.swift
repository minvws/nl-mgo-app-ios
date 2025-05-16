/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO

final class UpdateRequiredViewModelTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var sut: UpdateRequiredViewModel!
	
	override func setUp() {
		
		coordinatorSpy = AppCoordinatorSpy()
		sut = UpdateRequiredViewModel(coordinator: coordinatorSpy)
		super.setUp()
	}
	
	func test_reduce_actionButtonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.actionButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0).toEventually(equal(Coordination.Action.showAppStore))
	}
}
