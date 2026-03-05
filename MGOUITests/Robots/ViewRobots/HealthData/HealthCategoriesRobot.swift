/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

@MainActor class HealthCategoriesRobot: Robot {
	
	/// The app to test
	let app: XCUIApplication
	
	/// Create an Health Category Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application
	}
	
	// MARK: - Elements
	
	private func titleLabel(_ title: String) -> XCUIElement {
		app.staticTexts[title]
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
	
	private var addOrganizationsButton: XCUIElement {
		app.buttons["common.add_organizations"]
	}
	
	private var menuButton: XCUIElement {
		app.buttons["overview.menu"]
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
	
	@discardableResult
	func verifyAddOrganizationsButtonExists() -> Self {
		XCTAssertTrue(addOrganizationsButton.exists)
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
	func tapMenu() -> Self {
		menuButton.tap()
		return self
	}
	
	@discardableResult
	func swipeDownToCategory(_ category: String) -> Self {
		
		while !app.buttons[category].exists {
			app.swipeUp()
		}
		
		return self
	}
	
	@discardableResult
	func swipeUpToCategory(_ category: String) -> Self {
		
		while !app.buttons[category].exists {
			app.swipeDown()
		}
		
		return self
	}
	
	@discardableResult
	func swipeToTopCategory() -> Self {
		
		while !app.buttons["problems"].exists {
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
	
	@discardableResult
	func tapAddOrganizationsButton() -> OrganizationSearchRobot {
		addOrganizationsButton.tap()
		return OrganizationSearchRobot(app)
	}
	
	func verifyAllCategories() -> Self {
		
		verifyHeadingExists("Gezondheid")
		.verifyCategoryExists("problems")
		.verifyCategoryExists("allergies")
		.verifyCategoryExists("alerts")
		.swipeDownToCategory("vaccinations")
		.verifyCategoryExists("vaccinations")
		.swipeDownToCategory("mental_wellbeing")
		.verifyCategoryExists("mental_wellbeing")
		.swipeDownToCategory("lifestyle")
		.verifyCategoryExists("lifestyle")
		
		.swipeDownToCategory("treatments")
		.verifyHeadingExists("Zorg")
		.verifyCategoryExists("treatments")
		.swipeDownToCategory("plans")
		.verifyCategoryExists("plans")
		.swipeDownToCategory("medication")
		.verifyCategoryExists("medication")
		.swipeDownToCategory("appointments")
		.verifyCategoryExists("appointments")
		.swipeDownToCategory("documents")
		.verifyCategoryExists("documents")
		.swipeDownToCategory("medical_devices")
		.verifyCategoryExists("medical_devices")

		.swipeDownToCategory("measurements")
		.verifyHeadingExists("Onderzoek")
		.verifyCategoryExists("measurements")
		.swipeDownToCategory("lab_results")
		.verifyCategoryExists("lab_results")
		
		.swipeDownToCategory("patient")
		.verifyHeadingExists("Persoonlijk")
		.verifyCategoryExists("patient")
		.swipeDownToCategory("care_team")
		.verifyCategoryExists("care_team")
		
		return self
	}
}
