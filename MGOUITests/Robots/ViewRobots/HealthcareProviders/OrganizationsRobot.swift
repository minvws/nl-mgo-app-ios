/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
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

	private func healthOrganizationButton(_ provider: String) -> XCUIElement {
		app.buttons[provider]
	}
	
	// MARK: - Validations
	
	@discardableResult
	func verifyHealthcareOrganizationButtonExists(_ provider: String) -> Self {
		XCTAssertTrue(healthOrganizationButton(provider).exists)
		return self
	}

	// MARK: - Interactions
	
	@discardableResult
	func tapHealthcareOrganizationButton(_ provider: String) -> HealthCategoriesRobot {
		healthOrganizationButton(provider).tap()
		return HealthCategoriesRobot(app)
	}
}
