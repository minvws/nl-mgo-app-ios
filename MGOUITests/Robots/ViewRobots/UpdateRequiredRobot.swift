/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class UpdateRequiredRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an Introduction Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application
		XCTAssertTrue(titleLabel.waitForExistence(timeout: 5), "Expected 'IntroductionRobot' screen, but it didn't appear")
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
	func verifyUpdateButton() -> Self {
		XCTAssertTrue(updateButton.exists)
		return self
	}

	// MARK: - Interactions
	
}
