/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

@MainActor
final class ForgotPincodeFlowTests: XCTestCase {
	
	/*
	 This e2e test will test the forgot your pin code flow
	 - Press the cancel button on forgot your pin code sheet, reopen and press close
	 - Press the create new account button on forgot your pin code sheet, press no on the popup
	 - Press the create new account button on forgot your pin code sheet, press yes on the popup, press ok on the account removed page
	 */
	
	@MainActor
	func testForgotPincodeFlow_cancelAction_closeAction() {
		
		AppRobot()
			.launchApp(withPincode: "12345")
			.verifyForgotButtonExists()
			.tapForgotButton()
			.verifySubHeadingExists()
			.verifyCancelButtonExists()
			.verifyCreateNewAccountButtonExists()
			.verifyCloseSheetButtonExists()
			.tapCancelButton()
			.tapForgotButton()
			.tapCloseSheetButton()
	}
	
	@MainActor
	func testForgotPincodeFlow_cancelActionOnPopup() {
		
		AppRobot()
			.launchApp(withPincode: "12345")
			.tapForgotButton()
			.verifySubHeadingExists()
			.verifyCancelButtonExists()
			.verifyCreateNewAccountButtonExists()
			.tapCreateNewAccountButton()
			.verifyAlertHeadingExists()
			.verifyAlertSubHeadingExists()
			.verifyAlertOkButtonExists()
			.verifyAlertCancelButtonExists()
			.tapAlertCancelButton()
	}
	
	@MainActor
	func testForgotPincodeFlow_okActionOnPopup_accountRemovedShouldExits_okAction() {
		
		AppRobot()
			.launchApp(withPincode: "12345")
			.tapForgotButton()
			.tapCreateNewAccountButton()
			.tapAlertOkButton()
			.verifySubHeadingExists()
			.verifyOkButtonExists()
			.tapOkButton()
	}
}
