/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class PropositionRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an Proposition Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		
		self.app = application
		XCTAssertTrue(
			titleLabel.waitForExistence(timeout: timeOut),
			"Expected 'PropositionRobot' screen, but it didn't appear"
		)
	}
	
	// MARK: - Elements
	
	private var nextButton: XCUIElement {
		app.buttons["common.next"]
	}
	
	private var titleLabel: XCUIElement {
		app.staticTexts["proposition.heading"]
	}

	private var subHeadingLabel: XCUIElement {
		app.staticTexts["proposition.subheading"]
	}
	
	private func proposition(label: String) -> XCUIElement {
		app.staticTexts[label]
	}

	// MARK: - Validations
	
	@discardableResult
	func verifySubHeadingExists() -> Self {
		XCTAssertTrue(subHeadingLabel.exists)
		return self
	}
	
	@discardableResult
	func verifyPropositionExists(label: String) -> Self {
		XCTAssertTrue(proposition(label: label).exists)
		return self
	}
	
	// MARK: - Interactions
	
	@discardableResult
	func tapNextButton() -> PincodeRobot {
		nextButton.tap()
		return PincodeRobot(app)
	}
}
