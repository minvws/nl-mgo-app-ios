/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class HealthCategoriesRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an Health Category Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application	}
	
	// MARK: - Elements
	
	private func headingLabel(_ heading: String) -> XCUIElement {
		app.navigationBars.staticTexts[heading]
	}
	
	private var subHeadingLabel: XCUIElement {
		app.staticTexts["overview.subheading"]
	}
	
	private func healthCategory(_ category: String) -> XCUIElement {
		app.buttons[category]
	}
	
	// MARK: - Validations
	
	@discardableResult
	func verifyHeadingExists(_ heading: String) -> Self {
		XCTAssertTrue(headingLabel(heading).exists)
		return self
	}
	
	@discardableResult
	func verifySubHeadingExists() -> Self {
		XCTAssertTrue(subHeadingLabel.exists)
		return self
	}
	
	@discardableResult
	func verifyCategoryExists(_ category: String) -> Self {
		XCTAssertTrue(healthCategory(category).waitForExistence(timeout: 5.0))
		return self
	}

	// MARK: - Interactions
	
	@discardableResult
	func tapHealthCategory(_ category: String) -> HealthCategoryRobot {
		healthCategory(category).tap()
		return HealthCategoryRobot(app)
	}
}
