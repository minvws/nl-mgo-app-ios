/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class ForgotPincodeTests: XCTestCase {
	
	@MainActor
	func testForgotPincodeCancel() {
		
		AppRobot()
			.launchApp(withPincode: "12345")
			.tapForgotButton()
			.verifySubHeadingExists()
			.verifyCancelButtonExists()
			.verifyNewAccountButtonExists()
			.tapCancelButton()
	}
	
	@MainActor
	func testForgotPincodeAlertCancelPopup() {
		
		AppRobot()
			.launchApp(withPincode: "12345")
			.tapForgotButton()
			.verifySubHeadingExists()
			.verifyCancelButtonExists()
			.verifyNewAccountButtonExists()
			.tapNewAccountButton()
			.verifyAlertHeadingExists()
			.verifyAlertSubHeadingExists()
			.verifyAlertOkButtonExists()
			.verifyAlertCancelButtonExists()
			.tapAlertCancelButton()
	}
}
