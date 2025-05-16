/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class OrganizationListManualRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an Organization List Manual Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application
		XCTAssertTrue(
			titleLabel.waitForExistence(timeout: timeOut),
			"Expected 'OrganizationListManualRobot' screen, but it didn't appear"
		)
	}
	
	// MARK: - Elements
	
	private var titleLabel: XCUIElement {
		app.staticTexts["organization_search.heading"]
	}

	private func listElement(at index: Int) -> XCUIElement {
		app.buttons["organization_search.result_\(index)"]
	}
	
	// MARK: - Validations
	
	@discardableResult
	func verifyListElementExists(at index: Int) -> Self {
		XCTAssertTrue(listElement(at: index).waitForExistence(timeout: timeOut))
		return self
	}

	// MARK: - Interactions
	
	@discardableResult
	func swipeToListElement(at index: Int) -> Self {
		
		while !listElement(at: index).exists {
			app.swipeUp()
		}
		
		return self
	}
	
	@discardableResult
	func tapListElement(at index: Int) -> HealthCategoriesRobot {
		listElement(at: index).tap()
		return HealthCategoriesRobot(app)
	}
}
