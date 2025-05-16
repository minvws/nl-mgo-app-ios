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
		sut = ForgotPinCodeView(viewModel: ForgotPinCodeViewModel(coordinator: self.coordinatorSpy))
		super.setUp()
	}

	// MARK: - Actions -
	
	func test_cancel() throws {
		
		// Given
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "common.cancel")
		try view.view(CallToActionButton.self).find(button: "common.cancel").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.dismissForgotPinCode
	}
	
	func test_showDialog() throws {
		
		// Given
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "forgot_pincode.button")
		try view.view(CallToActionButton.self).find(button: "forgot_pincode.button").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
	}
	
	// MARK: - Snapshots -
	
	func test_forgotPinCodeView() {
		
		// Given
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
