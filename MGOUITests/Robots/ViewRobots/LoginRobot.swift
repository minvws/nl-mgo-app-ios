/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

/// The Robot for the Login scene
class LoginRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an Login Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		
		self.app = application
		XCTAssertTrue(
			titleLabel.waitForExistence(timeout: timeOut),
			"Expected 'LoginRobot' screen, but it didn't appear"
		)
	}
	
	// MARK: - Elements
	
	private var digidButton: XCUIElement {
		app.buttons["login.digid"]
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

	// MARK: - Interactions
	
	@discardableResult
	func tapDigiDButton() -> MockDigiDRobot {
		digidButton.tap()
		return MockDigiDRobot(app)
	}
}
