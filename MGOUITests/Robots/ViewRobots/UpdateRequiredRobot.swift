/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class UpdateRequiredRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an Update Required Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application
		XCTAssertTrue(
			titleLabel.waitForExistence(timeout: timeOut),
			"Expected 'IntroductionRobot' screen, but it didn't appear"
		)
	}
	
	// MARK: - Elements
	
	private var updateButton: XCUIElement {
		app.buttons["update_required.download"]
	}
	
	private var titleLabel: XCUIElement {
		app.staticTexts["update_required.heading"]
	}
	
	private var subHeadingLabel: XCUIElement {
		app.staticTexts["update_required.subheading"]
	}

	// MARK: - Validations
	
	@discardableResult
	func verifySubHeadingExists() -> Self {
		XCTAssertTrue(subHeadingLabel.exists)
		return self
	}
	
	@discardableResult
	func verifyUpdateButtonExists() -> Self {
		XCTAssertTrue(updateButton.exists)
		return self
	}

	// MARK: - Interactions
	
}
