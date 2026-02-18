/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOUI
import MGOFoundation
@testable import MGO

final class LoginInfoViewTests: XCTestCase {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	private var viewModel: LoginInfoViewModel!
	private var sut: LoginInfoView!
	
	override func setUp() {
		
		coordinatorSpy = AppCoordinatorSpy()
		viewModel = LoginInfoViewModel(coordinator: coordinatorSpy)
		
		super.setUp()
	}
	
	@MainActor private func createSut() {

		sut = LoginInfoView(viewModel: self.viewModel)
	}
	
	@MainActor func test_nextButtonPressed_shouldCallCoordinator() throws {
		
		// Given
		createSut()
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "common.next")
		try view.view(CallToActionButton.self).find(button: "common.next").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.nextButtonPressedOnLoginInfo
	}
}
