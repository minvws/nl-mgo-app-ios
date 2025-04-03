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
	
	private func titleLabel(_ title: String) -> XCUIElement {
		app.navigationBars.staticTexts[title]
	}

	private func headingLabel(_ heading: String) -> XCUIElement {
		app.staticTexts[heading]
	}
	
	private var subHeadingLabel: XCUIElement {
		app.staticTexts["overview.subheading"]
	}
	
	private func healthCategory(_ category: String) -> XCUIElement {
		app.buttons[category]
	}
	
	private var overviewButton: XCUIElement {
		app.buttons["bottombar.overview"]
	}
	
	private var healthcareProviderButton: XCUIElement {
		app.buttons["bottombar.healthcareproviders"]
	}
	
	private var settingsButton: XCUIElement {
		app.buttons["bottombar.settings"]
	}
	
	private var removeHealthcareOrganizationButton: XCUIElement {
		app.buttons["organizations.remove_organization"]
	}
	
	// MARK: - Validations
	
	@discardableResult
	func verifyTitleExists(_ title: String) -> Self {
		XCTAssertTrue(titleLabel(title).exists)
		return self
	}
	
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
	
	@discardableResult
	func verifyOverviewButtonExists() -> Self {
		XCTAssertTrue(overviewButton.exists)
		return self
	}
	
	@discardableResult
	func verifyHealthcareProviderButtonExists() -> Self {
		XCTAssertTrue(healthcareProviderButton.exists)
		return self
	}
	
	@discardableResult
	func verifySettingsButtonExists() -> Self {
		XCTAssertTrue(settingsButton.exists)
		return self
	}
	
	@discardableResult
	func verifyRemoveHealthcareOrganizationButton() -> Self {
		XCTAssertTrue(removeHealthcareOrganizationButton.exists)
		return self
	}

	// MARK: - Interactions
	
	@discardableResult
	func tapHealthCategory(_ category: String) -> HealthCategoryRobot {
		healthCategory(category).tap()
		return HealthCategoryRobot(app)
	}
	
	@discardableResult
	func tapOverviewTab() -> Self {
		overviewButton.tap()
		return self
	}
	
	@discardableResult
	func tapHealthcareProviderTab() -> OrganizationsRobot {
		healthcareProviderButton.tap()
		return OrganizationsRobot(app)
	}
	
	@discardableResult
	func swipeToRemoveHealthcareOrganizationButton() -> Self {
		
		while !removeHealthcareOrganizationButton.exists {
			app.swipeUp()
		}
		
		return self
	}
}
