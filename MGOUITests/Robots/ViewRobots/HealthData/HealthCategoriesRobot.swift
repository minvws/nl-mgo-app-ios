/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class HealthCategoriesRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an Health Category Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application
	}
	
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
	
	private var healthcareOrganizationButton: XCUIElement {
		app.buttons["bottombar.healthcareproviders"]
	}
	
	private var settingsButton: XCUIElement {
		app.buttons["bottombar.settings"]
	}
	
	private var removeHealthcareOrganizationButton: XCUIElement {
		app.buttons["organizations.remove_organization"]
	}
	
	private var toastHeading: XCUIElement {
		app.staticTexts["toast.heading"]
	}
	
	private var toastRecoverButton: XCUIElement {
		app.buttons["toast.subheading"]
	}
	
	private var toastCloseButton: XCUIElement {
		app.buttons["toast.close"]
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
	func verifyHealthcareOrganizationButtonExists() -> Self {
		XCTAssertTrue(healthcareOrganizationButton.exists)
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
	
	@discardableResult
	func verifyToastHeadingExists() -> Self {
		XCTAssertTrue(toastHeading.exists)
		return self
	}
	
	@discardableResult
	func verifyToastRecoverButtonExists() -> Self {
		XCTAssertTrue(toastRecoverButton.exists)
		return self
	}
	
	@discardableResult
	func verifyToastCloseExists() -> Self {
		XCTAssertTrue(toastCloseButton.exists)
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
	func tapHealthcareOrganizationTab() -> OrganizationsRobot {
		healthcareOrganizationButton.tap()
		return OrganizationsRobot(app)
	}
	
	@discardableResult
	func tapSettingsTab() -> SettingsRobot {
		settingsButton.tap()
		return SettingsRobot(app)
	}
	
	@discardableResult
	func swipeToRemoveHealthcareOrganizationButton() -> Self {
		
		while !removeHealthcareOrganizationButton.exists {
			app.swipeUp()
		}
		
		return self
	}
	
	@discardableResult
	func swipeToBottomCategory() -> Self {
		
		while !app.buttons["hc_payment.heading"].exists {
			app.swipeUp()
		}
		
		return self
	}
	
	@discardableResult
	func swipeToTopCategory() -> Self {
		
		while !app.buttons["hc_complaints.heading"].exists {
			app.swipeDown()
		}
		
		return self
	}
	
	@discardableResult
	func tapRemoveHealthcareOrganizationButton() -> RemoveHealthcareOrganizationRobot {
		removeHealthcareOrganizationButton.tap()
		return RemoveHealthcareOrganizationRobot(app)
	}
	
	@discardableResult
	func tapToastCloseButton() -> Self {
		toastCloseButton.tap()
		return self
	}
	
	@discardableResult
	func tapToastRecoverButton() -> Self {
		toastRecoverButton.tap()
		return self
	}
}
