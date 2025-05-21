/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class AddOrganizationRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an Add Organization Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application
		XCTAssertTrue(
			titleLabel.waitForExistence(timeout: timeOut),
			"Expected 'IntroductionRobot' screen, but it didn't appear"
		)
	}
	
	// MARK: - Elements
	
	private var searchButton: XCUIElement {
		app.buttons["common.search"]
	}
	
	private var titleLabel: XCUIElement {
		app.staticTexts["add_organization.heading"]
	}
	
	private var nameField: XCUIElement {
		app.textFields["add_organization.name"]
	}
	
	private var cityField: XCUIElement {
		app.textFields["add_organization.city"]
	}

	// MARK: - Validations
	
	@discardableResult
	func verifyNameFieldExists() -> Self {
		XCTAssertTrue(nameField.exists)
		return self
	}
	
	@discardableResult
	func verifyCityFieldExists() -> Self {
		XCTAssertTrue(cityField.exists)
		return self
	}
	
	@discardableResult
	func verifySearchButtonExists() -> Self {
		XCTAssertTrue(searchButton.exists)
		return self
	}

	// MARK: - Interactions
	
	@discardableResult
	func enterSearchFields(name: String, place: String) -> Self {
		
		nameField.tap()
		nameField.typeText(name)
		
		cityField.tap()
		cityField.typeText(place)
		
		return self
	}
	
	@discardableResult
	func tapSearchButton() -> OrganizationListManualRobot {
		searchButton.tap()
		return OrganizationListManualRobot(app)
	}
}
