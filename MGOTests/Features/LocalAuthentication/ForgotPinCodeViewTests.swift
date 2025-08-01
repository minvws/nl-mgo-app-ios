/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
import MGOUI
@testable import MGO

final class ForgotPinCodeViewTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var sut: ForgotPinCodeView!
	
	override func setUp() {
		
		coordinatorSpy = AppCoordinatorSpy()
		super.setUp()
	}
	
	@MainActor private func createSut() {
		
		sut = ForgotPinCodeView(viewModel: ForgotPinCodeViewModel(coordinator: self.coordinatorSpy))
	}

	// MARK: - Actions -
	
	@MainActor func test_cancel() throws {
		
		// Given
		createSut()
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "common.cancel")
		try view.view(CallToActionButton.self).find(button: "common.cancel").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.dismissForgotPinCode
	}
	
	@MainActor func test_showDialog() throws {
		
		// Given
		createSut()
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "forgot_pincode.button")
		try view.view(CallToActionButton.self).find(button: "forgot_pincode.button").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
	}
	
	// MARK: - Snapshots -
	
	@MainActor func test_forgotPinCodeView() {
		
		// Given
		createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
