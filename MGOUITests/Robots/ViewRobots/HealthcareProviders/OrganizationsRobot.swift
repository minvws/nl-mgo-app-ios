/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

/// The Robot for the Organizations scene
class OrganizationsRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an Organizations Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		
		self.app = application
		XCTAssertTrue(
			headingLabel.waitForExistence(timeout: timeOut),
			"Expected 'OrganizationsRobot' screen, but it didn't appear"
		)
	}
	
	// MARK: - Elements
	
	private var headingLabel: XCUIElement {
		app.navigationBars.staticTexts["Zorgaanbieders"]
	}

	private func healthOrganizationButton(_ organization: String) -> XCUIElement {
		app.buttons[organization]
	}
	
	// MARK: - Validations
	
	@discardableResult
	func verifyHealthcareOrganizationButtonExists(_ organization: String) -> Self {
		XCTAssertTrue(healthOrganizationButton(organization).exists)
		return self
	}

	// MARK: - Interactions
	
	@discardableResult
	func tapHealthcareOrganizationButton(_ organization: String) -> HealthCategoriesRobot {
		healthOrganizationButton(organization).tap()
		return HealthCategoriesRobot(app)
	}
}
