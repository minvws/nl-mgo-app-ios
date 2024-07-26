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
		sut = IntroductionViewModel(coordinator: coordinatorSpy, showAccountDeletedBanner: true)
		super.setUp()
	}

	func test_buttonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.nextButttonPressed)
		
		// Then
		expect(self.sut.banner) != nil
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.nextButtonPressedOnIntroduction
	}
	
	func test_onDisappear_shouldRemoveBaner() {
		
		// Given
		
		// When
		sut.reduce(.onDisappear)
		
		// Then
		expect(self.sut.banner) == nil
		expect(self.coordinatorSpy.invokedHandle) == false
	}
	
	func test_bannerCloseButtonPressed_shouldRemoveBanner() {
		
		// Given
		
		// When
		sut.reduce(.closeBanner)
		
		// Then
		expect(self.sut.banner) == nil
		expect(self.coordinatorSpy.invokedHandle) == false
	}
}
