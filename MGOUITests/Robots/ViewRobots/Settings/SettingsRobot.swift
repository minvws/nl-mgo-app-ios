/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class SettingsRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an Settings Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application
		XCTAssertTrue(
			titleLabel.waitForExistence(timeout: timeOut),
			"Expected 'SettingsRobot' screen, but it didn't appear"
		)
	}
	
	// MARK: - Elements
	
	private var aboutTheAppButton: XCUIElement {
		app.buttons["settings.about_this_app"]
	}

	private var advancedButton: XCUIElement {
		app.buttons["settings.advanced"]
	}
	
	private var alertCancelButton: XCUIElement {
		app.buttons["common.cancel"]
	}

	private var alertOkButton: XCUIElement {
		app.buttons["settings.reset_app.dialog.action"]
	}
	
	private var displayButton: XCUIElement {
		app.buttons["settings.display"]
	}
	
	private var logoutButton: XCUIElement {
		app.buttons["settings.log_out"]
	}
	
	private var resetApplicationButton: XCUIElement {
		app.buttons["settings.reset_app"]
	}
	
	private var securityButton: XCUIElement {
		app.buttons["settings.security"]
	}
	
	private var titleLabel: XCUIElement {
		app.navigationBars.staticTexts["Instellingen"]
	}

	// MARK: - Validations
	
	@discardableResult
	func verifyAboutTheAppButtonExists() -> Self {
		XCTAssertTrue(aboutTheAppButton.exists)
		return self
	}
	
	@discardableResult
	func verifyAdvancedButtonExists() -> Self {
		XCTAssertTrue(advancedButton.exists)
		return self
	}
	
	@discardableResult
	func verifyAlertCancelButtonExists() -> Self {
		XCTAssertTrue(alertCancelButton.exists)
		return self
	}
	
	@discardableResult
	func verifyAlertOkButtonExists() -> Self {
		XCTAssertTrue(alertOkButton.exists)
		return self
	}
	
	@discardableResult
	func verifyDisplayButtonExists() -> Self {
		XCTAssertTrue(displayButton.exists)
		return self
	}
	
	@discardableResult
	func verifyLogoutButtonExists() -> Self {
		XCTAssertTrue(logoutButton.exists)
		return self
	}
	
	@discardableResult
	func verifyResetApplicationButtonExists() -> Self {
		XCTAssertTrue(resetApplicationButton.exists)
		return self
	}
	
	@discardableResult
	func verifySecurityButtonExists() -> Self {
		XCTAssertTrue(securityButton.exists)
		return self
	}

	// MARK: - Interactions
	
	@discardableResult
	func tapAboutTheAppButton() -> AboutTheAppRobot {
		aboutTheAppButton.tap()
		return AboutTheAppRobot(app)
	}
	
	@discardableResult
	func tapAdvancedButton() -> AdvancedSettingsRobot {
		advancedButton.tap()
		return AdvancedSettingsRobot(app)
	}
	
	@discardableResult
	func tapAlertCancelButton() -> Self {
		alertCancelButton.tap()
		return self
	}
	
	@discardableResult
	func tapAlertOkButton() -> IntroductionRobot {
		alertOkButton.tap()
		return IntroductionRobot(app)
	}
	
	@discardableResult
	func tapDisplayButton() -> DisplaySettingsRobot {
		displayButton.tap()
		return DisplaySettingsRobot(app)
	}
	
	@discardableResult
	func tapLogoutButton() -> PincodeRobot {
		logoutButton.tap()
		return PincodeRobot(app)
	}
	
	@discardableResult
	func tapSecurityButton() -> SecuritySettingsRobot {
		securityButton.tap()
		return SecuritySettingsRobot(app)
	}
	
	@discardableResult
	func tapResetApplicationButton() -> Self {
		resetApplicationButton.tap()
		return self
	}
}
