/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class HealthCategoryRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an Health Category Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application
	}
	
	// MARK: - Elements
	
	private func headingLabel(_ heading: String) -> XCUIElement {
		app.navigationBars.staticTexts[heading]
	}

	private func sectionLabel(_ section: String) -> XCUIElement {
		app.staticTexts[section]
	}
	
	private func sectionButton(_ identifier: String) -> XCUIElement {
		app.buttons[identifier]
	}
	
	// MARK: - Validations
	
	@discardableResult
	func verifyHeadingExists(_ heading: String) -> Self {
		XCTAssertTrue(headingLabel(heading).exists)
		return self
	}
	
	@discardableResult
	func verifySectionExists(_ section: String) -> Self {
		XCTAssertTrue(sectionLabel(section).exists)
		return self
	}
	
	@discardableResult
	func verifySectionRowExists(_ section: String) -> Self {
		XCTAssertTrue(sectionLabel(section).exists)
		return self
	}
	
	@discardableResult
	func verifySectionButtonExists(_ index: Int, section: Int) -> Self {
		XCTAssertTrue(sectionButton("category_element_\(section)_\(index)").exists)
		return self
	}

	// MARK: - Interactions
	
	@discardableResult
	func tapSectionRow(_ index: Int, section: Int) -> HealthUISchemaRobot {
		sectionButton("category_element_\(section)_\(index)").tap()
		return HealthUISchemaRobot(app)
	}
}
