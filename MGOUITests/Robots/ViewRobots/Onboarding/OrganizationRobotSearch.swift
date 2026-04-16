/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

@MainActor class OrganizationSearchRobot: Robot {
	
	/// The app to test
	let app: XCUIApplication
	
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
	
	private var titleLabel: XCUIElement {
		app.staticTexts["search_organization.heading"]
	}
	
	private var subHeadingLabel: XCUIElement {
		app.staticTexts["search_organization.subheading"]
	}
	
	private var searchField: XCUIElement {
		app.textFields["input"]
	}
	
	private func listElement(id: String) -> XCUIElement {
		app.buttons["button_\(id)"]
	}
	
	private var alertOkButton: XCUIElement {
		app.buttons["confirmationAlertCoverView.action"]
	}

	// MARK: - Validations
	
	@discardableResult
	func verifySubHeadingExists() -> Self {
		XCTAssertTrue(subHeadingLabel.exists)
		return self
	}
	
	@discardableResult
	func verifySearchFieldExists() -> Self {
		XCTAssertTrue(searchField.exists)
		return self
	}
	
	@discardableResult
	func verifyListElementExists(id: String) -> Self {
		XCTAssertTrue(listElement(id: id).waitForExistence(timeout: timeOut))
		return self
	}
	
	@discardableResult
	func verifyAlertOkButtonExists() -> Self {
		XCTAssertTrue(alertOkButton.exists)
		return self
	}

	// MARK: - Interactions
	
	@discardableResult
	func enterSearchField(_ text: String) -> Self {
		
		searchField.tap()
		searchField.typeText(text)
	
		return self
	}
	
	@discardableResult
	func tapListElement(id: String) -> Self {
		
		if !listElement(id: id).exists {
			swipeToListElement(id: id)
		}
		listElement(id: id).tap()
		return self
	}
	
	@discardableResult
	func tapAlertOkButton() -> HealthCategoriesRobot {
		alertOkButton.firstMatch.tap()
		return HealthCategoriesRobot(app)
	}
	
	@discardableResult
	func swipeToListElement(id: String) -> Self {
		
		while !listElement(id: id).exists {
			app.swipeUp()
		}
		
		return self
	}
}
