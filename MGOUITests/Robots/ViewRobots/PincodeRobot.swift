/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class PincodeRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an Pincode Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		
		self.app = application
		XCTAssertTrue(titleLabel.waitForExistence(timeout: 5), "Expected 'PincodeRobot' screen, but it didn't appear")
	}
	
	// MARK: - Elements
	
	private var titleLabel: XCUIElement {
		Heading.pincode.element
	}
	
	private func subHeading(_ subHeading: String) -> XCUIElement {
		app.staticTexts[subHeading]
	}
	
	private func errorText(_ error: String) -> XCUIElement {
		app.staticTexts[error]
	}

	// MARK: - Validations
	
	@discardableResult
	func verifySubHeadingExists(_ label: String) -> Self {
		XCTAssertTrue(subHeading(label).exists)
		return self
	}
	
	@discardableResult
	func verifyErrorText(_ error: String) -> Self {
		XCTAssertTrue(errorText(error).exists)
		return self
	}
	
	// MARK: - Interactions
	
	@discardableResult
	func enterPinCode(_ code: String) -> Self {
		for element in Array(code) {
			app.buttons[String(element)].tap()
		}
		return self
	}
	
	@discardableResult
	func enterConfirmationPinCode(_ code: String) -> LoginRobot {
		enterPinCode(code)
		return LoginRobot(app)
	}
}
