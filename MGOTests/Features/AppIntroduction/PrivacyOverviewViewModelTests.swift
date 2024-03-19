/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO

final class PrivacyOverviewViewModelTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var sut: PrivacyOverviewViewModel!
	
	override func setUp() {
		
		coordinatorSpy = AppCoordinatorSpy()
		sut = PrivacyOverviewViewModel(coordinator: coordinatorSpy)
		super.setUp()
	}

	func test_buttonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.nextButttonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == AppCoordination.Action.nextButtonPressedOnPrivacyOverview
	}
	
	func test_privacyLinkClicked_shouldChangeState() {
		
		// Given
		
		// When
		sut.reduce(.privacyLinkClicked)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == AppCoordination.Action.showPrivacyStatement
	}
	
	func test_backButtonPressed_shouldChangeState() {
		
		// Given
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == AppCoordination.Action.backButtonPressed
	}
}
