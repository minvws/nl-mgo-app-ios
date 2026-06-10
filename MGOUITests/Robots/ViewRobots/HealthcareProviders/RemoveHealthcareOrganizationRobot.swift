/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

/// Robot for the remove-organization confirmation alert
/// (`ConfirmationAlertCoverView`, presented from `HealthCategoriesView`).
@MainActor class RemoveHealthcareOrganizationRobot: Robot {
	
	let app: XCUIApplication
	
	init(_ application: XCUIApplication) {
		
		self.app = application
		XCTAssertTrue(
			removeButton.waitForExistence(timeout: timeOut),
			"Expected remove-organization confirmation alert to appear"
		)
	}
	
	// MARK: - Elements
	
	private var cancelButton: XCUIElement {
		app.buttons["confirmationAlertCoverView.cancel"]
	}
	
	private var removeButton: XCUIElement {
		app.buttons["confirmationAlertCoverView.action"]
	}
	
	// MARK: - Validations
	
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
	
	// MARK: - Interactions
	
	@discardableResult
	func tapCancelButton() -> HealthCategoriesRobot {
		cancelButton.tap()
		return HealthCategoriesRobot(app)
	}
	
	@discardableResult
	func tapRemoveButton() -> HealthCategoriesRobot {
		removeButton.tap()
		return HealthCategoriesRobot(app)
	}
}
