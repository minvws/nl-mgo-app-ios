/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

@MainActor class OrganizationListAutomaticRobot: Robot {
	
	/// The app to test
	let app: XCUIApplication
	
	/// Create an Organization List Automatic Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application
		XCTAssertTrue(
			titleLabel.waitForExistence(timeout: timeOut),
			"Expected 'OrganizationListAutomaticRobot' screen, but it didn't appear"
		)
	}
	
	// MARK: - Elements
	
	private var titleLabel: XCUIElement {
		app.staticTexts["organization_search.heading"]
	}

	private func listElement(at index: Int) -> XCUIElement {
		app.buttons["organization_search.result_\(index)"]
	}
	
	private var overviewButton: XCUIElement {
		app.buttons["common.to_overview"]
	}

	// MARK: - Validations
	
	@discardableResult
	func verifyListElementExists(at index: Int) -> Self {
		XCTAssertTrue(listElement(at: index).waitForExistence(timeout: timeOut))
		return self
	}
	
	@discardableResult
	func verifyOverviewButtonExists() -> Self {
		XCTAssertTrue(overviewButton.exists)
		return self
	}

	// MARK: - Interactions
	
	@discardableResult
	func tapListElement(at index: Int) -> Self {
		listElement(at: index).tap()
		return self
	}
	
	@discardableResult
	func tapOverviewButton() -> HealthCategoriesRobot {
		overviewButton.tap()
		return HealthCategoriesRobot(app)
	}
}
