/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOUI
@testable import MGO

final class IntroductionViewTests: XCTestCase {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	private var viewModel: IntroductionViewModel!
	private var sut: IntroductionView!
	
	override func setUp() {
		
		coordinatorSpy = AppCoordinatorSpy()
		
		super.setUp()
	}
	
	func createSut(withToast: Bool = false) {
		
		viewModel = IntroductionViewModel(coordinator: coordinatorSpy, showAccountDeletedToast: withToast)
		sut = IntroductionView(viewModel: self.viewModel)
	}
	
	func test_appIntroductionView() {
		
		// Given
		createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_appIntroductionView_withToast() {
		
		// Given
		createSut(withToast: true)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_nextButtonPressed_shouldCallCoordinator() throws {
		
		// Given
		createSut(withToast: true)
		
		// When
		try sut.inspect().find(viewWithAccessibilityIdentifier: "common.next").button().tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.nextButtonPressedOnIntroduction
	}
}
