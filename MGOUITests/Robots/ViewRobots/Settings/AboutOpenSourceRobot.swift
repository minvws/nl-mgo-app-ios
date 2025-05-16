/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class AboutOpenSourceRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an About Open Source Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application
		XCTAssertTrue(
			titleLabel.waitForExistence(timeout: timeOut),
			"Expected 'AboutOpenSourceRobot' screen, but it didn't appear"
		)
	}
	
	// MARK: - Elements

	private var previousButton: XCUIElement {
		app.buttons["common.previous"]
	}
	
	private var titleLabel: XCUIElement {
		app.navigationBars.staticTexts["Open-source bibliotheken"]
	}
	
	private var subHeadingLabel: XCUIElement {
		app.staticTexts["settings.about_this_app.open_source.subheading"]
	}
	
	// MARK: - Validations
	
	@discardableResult
	func verifyPreviousButtonExists() -> Self {
		XCTAssertTrue(previousButton.exists)
		return self
	}

	@discardableResult
	func verifySubHeadingExists() -> Self {
		XCTAssertTrue(subHeadingLabel.exists)
		return self
	}
	
	// MARK: - Interactions
	
	@discardableResult
	func tapPreviousButton() -> AboutTheAppRobot {
		previousButton.tap()
		return AboutTheAppRobot(app)
	}
}
