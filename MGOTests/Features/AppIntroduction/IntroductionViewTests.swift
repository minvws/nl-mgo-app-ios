/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
		viewModel = IntroductionViewModel(coordinator: coordinatorSpy)
		sut = IntroductionView(viewModel: self.viewModel)
		
		super.setUp()
	}
	
	func test_appIntroductionView() {
		
		// Given
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_nextButtonPressed_shouldCallCoordinator() throws {
		
		// Given
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "common.next")
		try view.view(CallToActionButton.self).find(button: "common.next").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.nextButtonPressedOnIntroduction
	}
}
