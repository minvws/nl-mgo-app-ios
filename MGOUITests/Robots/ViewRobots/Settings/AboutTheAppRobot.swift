/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class AboutTheAppRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an About the app Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application
		XCTAssertTrue(
			titleLabel.waitForExistence(timeout: timeOut),
			"Expected 'AboutTheAppRobot' screen, but it didn't appear"
		)
	}
	
	// MARK: - Elements

	private var accessibilityButton: XCUIElement {
		app.buttons["settings.about_this_app.accessibility"]
	}
	
	private var aboutTheAppTitle: XCUIElement {
		app.staticTexts["common.app_name"]
	}
	
	private var logo: XCUIElement {
		app.images["settings.about_this_app.logo"]
	}

	private var previousButton: XCUIElement {
		app.buttons["common.previous"]
	}

	private var versionButton: XCUIElement {
		app.buttons["settings.about_this_app.version"]
	}
	
	private var alertOkButton: XCUIElement {
		app.buttons["common.ok"]
	}
	
	private var safetyTipsButton: XCUIElement {
		app.buttons["settings.about_this_app.safety"]
	}
	
	private var openSourceButton: XCUIElement {
		app.buttons["settings.about_this_app.open_source"]
	}
	
	private var privacyButton: XCUIElement {
		app.buttons["settings.about_this_app.privacy"]
	}

	private var titleLabel: XCUIElement {
		app.navigationBars.staticTexts["Over deze app"]
	}

	// MARK: - Validations
	
	@discardableResult
	func verifyAboutTheAppTitleExists() -> Self {
		XCTAssertTrue(aboutTheAppTitle.exists)
		return self
	}
	
	@discardableResult
	func verifyLogoExists() -> Self {
		XCTAssertTrue(logo.exists)
		return self
	}
	
	@discardableResult
	func verifyPreviousButtonExists() -> Self {
		XCTAssertTrue(previousButton.exists)
		return self
	}

	@discardableResult
	func verifyVersionButtonExists() -> Self {
		XCTAssertTrue(versionButton.exists)
		return self
	}
	
	@discardableResult
	func verifyAlertOkButtonExists() -> Self {
		XCTAssertTrue(alertOkButton.exists)
		return self
	}
	
	@discardableResult
	func verifySafetyTipsButtonExists() -> Self {
		XCTAssertTrue(safetyTipsButton.exists)
		return self
	}
	
	@discardableResult
	func verifyOpenSourceButtonExists() -> Self {
		XCTAssertTrue(openSourceButton.exists)
		return self
	}
	
	@discardableResult
	func verifyAccessibilityButtonExists() -> Self {
		XCTAssertTrue(accessibilityButton.exists)
		return self
	}
	
	@discardableResult
	func verifyPrivacyButtonExists() -> Self {
		XCTAssertTrue(privacyButton.exists)
		return self
	}
	
	// MARK: - Interactions
	
	@discardableResult
	func tapPreviousButton() -> SettingsRobot {
		previousButton.tap()
		return SettingsRobot(app)
	}
	
	@discardableResult
	func tapVersionButton() -> Self {
		versionButton.tap()
		return self
	}
	
	@discardableResult
	func tapAlertOkButton() -> Self {
		alertOkButton.tap()
		return self
	}
	
	@discardableResult
	func tapAboutAccessibilityButton() -> AboutAccessibilityRobot {
		accessibilityButton.tap()
		return AboutAccessibilityRobot(app)
	}
	
	@discardableResult
	func tapAboutSafetyTipsButton() -> AboutSafetyTipsRobot {
		safetyTipsButton.tap()
		return AboutSafetyTipsRobot(app)
	}
	
	@discardableResult
	func tapAboutOpenSourceButton() -> AboutOpenSourceRobot {
		openSourceButton.tap()
		return AboutOpenSourceRobot(app)
	}
	
	@discardableResult
	func tapAboutPrivacyButton() -> AboutPrivacyRobot {
		privacyButton.tap()
		return AboutPrivacyRobot(app)
	}
}
