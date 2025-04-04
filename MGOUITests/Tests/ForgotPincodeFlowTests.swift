/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class ForgotPincodeFlowTests: XCTestCase {
	
	/*
	 This e2e test will test the forgot your pincode flow
	 - Verify the existence of the forgot your pincode button on pincode entry
	 - Press the cancel button on forgot your pincode sheet
	 - Press the close button on forgot your pincode sheet
	 - Press the create new account button on forgot your pincode sheet, press no on the popup
	 - Press the create new account button on forgot your pincode sheet, press yes on the popup, press ok on the account removed page
	 */
	
	@MainActor
	func testForgotPincode_forgotButtonShouldExist() {
		AppRobot()
			.launchApp(withPincode: "12345")
			.verifyForgotButtonExists()
	}
	
	@MainActor
	func testForgotPincode_cancelAction() {
		
		AppRobot()
			.launchApp(withPincode: "12345")
			.tapForgotButton()
			.verifySubHeadingExists()
			.verifyCancelButtonExists()
			.verifyCreateNewAccountButtonExists()
			.verifyCloseSheetButtonExists()
			.tapCancelButton()
	}
	
	@MainActor
	func testForgotPincode_closeAction() {
		
		AppRobot()
			.launchApp(withPincode: "12345")
			.tapForgotButton()
			.verifySubHeadingExists()
			.verifyCancelButtonExists()
			.verifyCreateNewAccountButtonExists()
			.verifyCloseSheetButtonExists()
			.tapCloseSheetButton()
	}
	
	@MainActor
	func testForgotPincode_cancelActionOnPopup() {
		
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
	func testForgotPincode_okActionOnPopup_accountRemovedShouldExits_okAction() {
		
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
