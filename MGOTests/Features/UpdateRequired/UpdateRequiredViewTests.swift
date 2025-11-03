/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOUI
@testable import MGO

final class UpdateRequiredViewTests: XCTestCase {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	private var viewModel: UpdateRequiredViewModel!
	private var sut: UpdateRequiredView!
	
	@MainActor private func createSut() {
		
		coordinatorSpy = AppCoordinatorSpy()
		viewModel = UpdateRequiredViewModel(coordinator: coordinatorSpy)
		sut = UpdateRequiredView(viewModel: self.viewModel)
	}
	
	@MainActor func test_updateRequiredView() {
		
		// Given
		createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content, isRecording: true)
	}
	
	@MainActor func test_actionButtonPressed_shouldCallCoordinator() throws {
		
		// Given
		createSut()
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "update_required.download")
		try view.view(CallToActionButton.self).find(button: "update_required.download").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showAppStore
	}
}
