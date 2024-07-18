/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest

final class ForgotThePincodeFlow: BaseUITest {
	
	override func setUpWithError() throws {
		
		app.launchArguments.append("-skipOnboarding")
		app.launchArguments.append("-pincode:12345")
		try super.setUpWithError()
	}
	
	func test_forgotPincodeFlow_userPressesCancel_shouldRevertToPincodeScreen() {
	
		// Navigate to forgot pincode screen
		app.buttons["pincode.forgot"].tap()
		
		assertForgotPincodeScreen()

		// Cancel
		app.buttons["common.cancel"].tap()
		
		assertPincodeScreen()
	}

	func test_forgotPincodeFlow_userClosesSheet_shouldRevertToPincodeScreen() {
	
		// Navigate to forgot pincode screen
		app.buttons["pincode.forgot"].tap()
		
		assertForgotPincodeScreen()

		// Close the sheet
		app.buttons["common.close"].tap()
		
		assertPincodeScreen()
	}
	
	func test_forgotPincodeFlow_userPressesCreateNewAccount_cancelsDialog() {
		
		// Navigate to forgot pincode screen
		app.buttons["pincode.forgot"].tap()
		
		assertForgotPincodeScreen()
		
		// Create new account
		app.buttons["forgot_pincode.button"].tap()

		// Cancel through dialog
		app.buttons["common.no"].tap()
		
		assertForgotPincodeScreen()
	}
	
	func test_forgotPincodeFlow_userPressesCreateNewAccount_acceptsDialog_shouldShowIntroductionScreen() {
		
		// Navigate to forgot pincode screen
		app.buttons["pincode.forgot"].tap()
		
		assertForgotPincodeScreen()
		
		// Create new account
		app.buttons["forgot_pincode.button"].tap()

		// Accept through dialog
		app.buttons["common.yes"].tap()
		
		assertIntroductionScreen()
		
		assertIntroductionToast()
		
		// Dismiss Toast
		app.buttons["toast.close"].tap()
	}
	
	@available(iOS 17.0, *)
	func test_forgotPincodeFlow_accessibilityAudit() {
		
		guard accessibilityAuditEnabled else { return }
		
		// Navigate to forgot pincode screen
		app.buttons["pincode.forgot"].tap()
		
		do {
			try app.performAccessibilityAudit()
		} catch {
			XCTFail("The automated accessibility audit fail because [\(error.localizedDescription)]")
		}
	}
}

// MARK: - Assertions -

extension BaseUITest {
	
	/// Are we on the Forgot Pincode screen?
	func assertForgotPincodeScreen() {
		
		app.textExists("forgot_pincode.heading")
		app.textExists("forgot_pincode.subheading")
	}

	/// Are we on the Introduction screen?
	func assertIntroductionScreen() {
		
		app.textExists("introduction.heading")
	}
	
	/// is the toast shown on the introduction screen?
	func assertIntroductionToast() {
		
		app.textExists("toast.heading")
		app.textExists("toast.subheading")
	}
}
