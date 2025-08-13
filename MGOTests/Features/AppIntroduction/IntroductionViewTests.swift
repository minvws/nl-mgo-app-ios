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
	
	@MainActor private func createSut() {
		
		coordinatorSpy = AppCoordinatorSpy()
		viewModel = IntroductionViewModel(coordinator: coordinatorSpy)
		sut = IntroductionView(viewModel: self.viewModel)
	}
	
	@MainActor func test_appIntroductionView() {
		
		// Given
		createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_nextButtonPressed_shouldCallCoordinator() throws {
		
		// Given
		createSut()
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "common.next")
		try view.view(CallToActionButton.self).find(button: "common.next").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.nextButtonPressedOnIntroduction
	}
}
