/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class IntroductionRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an Introduction Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application
		XCTAssertTrue(titleLabel.waitForExistence(timeout: 5), "Expected 'IntroductionRobot' screen, but it didn't appear")
	}
	
	// MARK: - Elements
	
	private var nextButton: XCUIElement {
		app.buttons["common.next"]
	}
	
	private var titleLabel: XCUIElement {
		app.staticTexts["introduction.heading"]
	}
	
	private var subHeadingLabel: XCUIElement {
		app.staticTexts["introduction.subheading"]
	}

	// MARK: - Validations
	
	@discardableResult
	func verifySubHeadingExists() -> Self {
		XCTAssertTrue(subHeadingLabel.exists)
		return self
	}

	// MARK: - Interactions
	
	@discardableResult
	func tapNextButton() -> PropositionRobot {
		nextButton.tap()
		return PropositionRobot(app)
	}
}
