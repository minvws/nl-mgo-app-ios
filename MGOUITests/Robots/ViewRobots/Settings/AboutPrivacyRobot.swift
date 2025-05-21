/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class AboutPrivacyRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an About Privacy Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application
		XCTAssertTrue(
			closeButton.waitForExistence(timeout: timeOut),
			"Expected 'AboutPrivacyRobot' screen, but it didn't appear"
		)
	}
	
	// MARK: - Elements

	private var closeButton: XCUIElement {
		app.buttons["common.close"]
	}
	
	private var safariButton: XCUIElement {
		app.buttons["safariButton"]
	}

	// MARK: - Validations
	
	@discardableResult
	func verifySafariButtonExists() -> Self {
		XCTAssertTrue(safariButton.exists)
		return self
	}
	
	// MARK: - Interactions
	
	@discardableResult
	func tapCloseButton() -> AboutTheAppRobot {
		closeButton.tap()
		return AboutTheAppRobot(app)
	}
}
