/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest

final class ForgotPincodeUITests: BaseUITest {
	
	override func setUpWithError() throws {
		app.launchArguments.append("-hasPincodeSet")
		try super.setUpWithError()
	}
	
	func test_forgotPincode_cancel() {
	
		// Navigate to forgot pincode scene
		app.buttons["pincode.forgot"].tap()
		
		// Assert Forgot Pincode scene
		app.textExists("forgot_pincode.heading")
		app.textExists("forgot_pincode.subheading")

		// Cancel
		app.buttons["common.cancel"].tap()
	}

	func test_forgotPincode_closeSheet() {
	
		// Navigate to forgot pincode scene
		app.buttons["pincode.forgot"].tap()
		
		// Assert Forgot Pincode scene
		app.textExists("forgot_pincode.heading")
		app.textExists("forgot_pincode.subheading")

		// Close the sheet
		app.buttons["common.close"].tap()
	}
	
	func test_forgotPincode_cancelThroughDialog() {
		
		// Navigate to forgot pincode scene
		app.buttons["pincode.forgot"].tap()
		
		// Assert Forgot Pincode scene
		app.textExists("forgot_pincode.heading")
		app.textExists("forgot_pincode.subheading")
		
		// Create new account
		app.buttons["forgot_pincode.button"].tap()

		// Cancel through dialog
		app.buttons["common.no"].tap()
	}
	
	func test_forgotPincode_acceptDialog_shouldGoToIntroduction() {
		
		// Navigate to forgot pincode scene
		app.buttons["pincode.forgot"].tap()
		
		// Assert Forgot Pincode scene
		app.textExists("forgot_pincode.heading")
		app.textExists("forgot_pincode.subheading")
		
		// Create new account
		app.buttons["forgot_pincode.button"].tap()

		// Accept through dialog
		app.buttons["common.yes"].tap()
		
		// Assert Introduction
		app.textExists("introduction.heading")
		
		// Assert Banner
		app.textExists("toast.heading")
		app.textExists("toast.subheading")
		
		// Dismiss Toast
		app.buttons["toast.close"].tap()
	}
}
