/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOUI
@testable import MGO

final class AppIntroductionViewTests: XCTestCase {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	private var viewModel: AppIntroductionViewModel!
	private var sut: AppIntroductionView!
	
	override func setUp() {
		
		coordinatorSpy = AppCoordinatorSpy()
		
		super.setUp()
	}
	
	func createSut(withToast: Bool = false) {
		
		viewModel = AppIntroductionViewModel(coordinator: coordinatorSpy, showAccountDeletedToast: withToast)
		sut = AppIntroductionView(viewModel: self.viewModel)
	}
	
	func test_appIntroductionView() {
		
		// Given
		createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_nextButtonPressed_shouldCallCoordinator() throws {
		
		// Given
		createSut(withToast: true)
		
		// When
		try sut.inspect().find(viewWithTag: "onboarding_action").button().tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.nextButtonPressedOnAppIntroduction
	}
}
