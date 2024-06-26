/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO

final class IntroductionViewModelTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var sut: IntroductionViewModel!
	
	override func setUp() {
		
		coordinatorSpy = AppCoordinatorSpy()
		sut = IntroductionViewModel(coordinator: coordinatorSpy, showAccountDeletedToast: true)
		super.setUp()
	}

	func test_buttonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.nextButttonPressed)
		
		// Then
		expect(self.sut.toast) != nil
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.nextButtonPressedOnAppIntroduction
	}
	
	func test_onDisappear_shouldRemoveToast() {
		
		// Given
		
		// When
		sut.reduce(.onDisappear)
		
		// Then
		expect(self.sut.toast) == nil
		expect(self.coordinatorSpy.invokedHandle) == false
	}
	
	func test_toastCloseButtonPressed_shouldRemoveToast() {
		
		// Given
		
		// When
		sut.reduce(.closeToast)
		
		// Then
		expect(self.sut.toast) == nil
		expect(self.coordinatorSpy.invokedHandle) == false
	}
}
