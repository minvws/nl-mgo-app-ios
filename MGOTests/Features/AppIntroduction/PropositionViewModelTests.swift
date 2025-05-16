/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO

final class PropositionViewModelTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var sut: PropositionViewModel!
	
	override func setUp() {
		
		coordinatorSpy = AppCoordinatorSpy()
		sut = PropositionViewModel(coordinator: coordinatorSpy)
		super.setUp()
	}

	func test_buttonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.nextButttonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.nextButtonPressedOnProposition
	}
	
	func test_privacyLinkClicked_shouldChangeState() {
		
		// Given
		
		// When
		sut.reduce(.privacyLinkClicked)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showPrivacyStatement
	}
	
	func test_backButtonPressed_shouldChangeState() {
		
		// Given
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
}
