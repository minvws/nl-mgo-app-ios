/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

/// The Robot for the Account Removed scene
class AccountRemovedRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an Login Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		
		self.app = application
		XCTAssertTrue(
			titleLabel.waitForExistence(timeout: timeOut),
			"Expected 'AccountRemovedRobot' screen, but it didn't appear"
		)
	}
	
	// MARK: - Elements
	
	private var okButton: XCUIElement {
		app.buttons["account_removed.action"]
	}
	
	private var titleLabel: XCUIElement {
		app.staticTexts["imagecontentview.heading"]
	}
	
	private var subHeadingLabel: XCUIElement {
		app.staticTexts["imagecontentview.subheading"]
	}

	// MARK: - Validations
	
	@discardableResult
	func verifySubHeadingExists() -> Self {
		XCTAssertTrue(subHeadingLabel.exists)
		return self
	}
	
	@discardableResult
	func verifyOkButtonExists() -> Self {
		XCTAssertTrue(okButton.exists)
		return self
	}

	// MARK: - Interactions
	
	@discardableResult
	func tapOkButton() -> PincodeRobot {
		okButton.tap()
		return PincodeRobot(app)
	}
}
