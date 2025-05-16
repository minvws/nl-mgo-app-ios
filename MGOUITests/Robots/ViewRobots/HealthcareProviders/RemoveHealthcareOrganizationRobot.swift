/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

/// The Robot for the Remove Healthcare Organization scene
class RemoveHealthcareOrganizationRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an Login Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		
		self.app = application
		XCTAssertTrue(
			titleLabel.waitForExistence(timeout: timeOut),
			"Expected 'RemoveHealthcareOrganizationRobot' screen, but it didn't appear"
		)
	}
	
	// MARK: - Elements
	
	private var cancelButton: XCUIElement {
		app.buttons["remove_organization.cancel"]
	}
	
	private var removeButton: XCUIElement {
		app.buttons["remove_organization.remove"]
	}
	
	private var closeButton: XCUIElement {
		app.buttons["common.close"]
	}
	
	private var titleLabel: XCUIElement {
		app.staticTexts["remove_organization.heading"]
	}
	
	private var subHeadingLabel: XCUIElement {
		app.staticTexts["remove_organization.subheading"]
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
	func verifyRemoveButtonExists() -> Self {
		XCTAssertTrue(removeButton.exists)
		return self
	}
	
	@discardableResult
	func verifyCloseButtonExists() -> Self {
		XCTAssertTrue(closeButton.exists)
		return self
	}

	// MARK: - Interactions
	
	@discardableResult
	func tapCancelButton() -> HealthCategoriesRobot {
		cancelButton.tap()
		return HealthCategoriesRobot(app)
	}
	
	@discardableResult
	func tapCloseButton() -> HealthCategoriesRobot {
		closeButton.tap()
		return HealthCategoriesRobot(app)
	}
	
	@discardableResult
	func tapRemoveButton() -> HealthCategoriesRobot {
		removeButton.tap()
		return HealthCategoriesRobot(app)
	}
}
