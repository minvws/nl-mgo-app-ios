/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

/// The Robot for the Forgot Pin code scene
class ForgotPincodeRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an Forgot Pincode Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		
		self.app = application
		XCTAssertTrue(
			titleLabel.waitForExistence(timeout: timeOut),
			"Expected 'ForgotPincodeRobot' screen, but it didn't appear"
		)
	}
	
	// MARK: - Elements
	
	private var cancelButton: XCUIElement {
		app.buttons["common.cancel"]
	}
	
	private var newAccountButton: XCUIElement {
		app.buttons["forgot_pincode.button"]
	}
	
	private var titleLabel: XCUIElement {
		app.staticTexts["forgot_pincode.heading"]
	}
	
	private var subHeadingLabel: XCUIElement {
		app.staticTexts["forgot_pincode.subheading"]
	}
	
	private var alertHeadingLabel: XCUIElement {
		app.staticTexts["Nieuw account maken?"]
	}
	
	private var alertSubHeadingLabel: XCUIElement {
		app.staticTexts["Je kunt je gegevens straks opnieuw ophalen. Het andere account wordt verwijderd."]
	}
	
	private var yesButton: XCUIElement {
		app.buttons["common.yes"]
	}
	
	private var noButton: XCUIElement {
		app.buttons["common.no"]
	}
	
	// MARK: - Validations
	
	@discardableResult
	func verifySubHeadingExists() -> Self {
		XCTAssertTrue(subHeadingLabel.exists)
		return self
	}
	
	@discardableResult
	func verifyCancelButtonExists() -> Self {
		XCTAssertTrue(cancelButton.exists)
		return self
	}
	
	@discardableResult
	func verifyNewAccountButtonExists() -> Self {
		XCTAssertTrue(newAccountButton.exists)
		return self
	}
	
	@discardableResult
	func verifyAlertHeadingExists() -> Self {
		XCTAssertTrue(alertHeadingLabel.exists)
		return self
	}
	
	@discardableResult
	func verifyAlertSubHeadingExists() -> Self {
		XCTAssertTrue(alertSubHeadingLabel.exists)
		return self
	}
	
	@discardableResult
	func verifyAlertCancelButtonExists() -> Self {
		XCTAssertTrue(noButton.exists)
		return self
	}
	
	@discardableResult
	func verifyAlertOkButtonExists() -> Self {
		XCTAssertTrue(yesButton.exists)
		return self
	}
	
	// MARK: - Interactions
	
	@discardableResult
	func tapCancelButton() -> PincodeRobot {
		cancelButton.tap()
		return PincodeRobot(app)
	}
	
	@discardableResult
	func tapNewAccountButton() -> Self {
		newAccountButton.tap()
		return self
	}
	
	@discardableResult
	func tapAlertCancelButton() -> Self {
		noButton.tap()
		return self
	}
	
	@discardableResult
	func tapAlertOkButton() -> AccountRemovedRobot {
		yesButton.tap()
		return AccountRemovedRobot(app)
	}
}
