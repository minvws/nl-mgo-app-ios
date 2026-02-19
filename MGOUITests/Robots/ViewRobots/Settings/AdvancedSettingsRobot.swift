/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

@MainActor class AdvancedSettingsRobot: Robot {
	
	/// The app to test
	let app: XCUIApplication
	
	/// Create an Advanced Settings Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application
		XCTAssertTrue(
			titleLabel.waitForExistence(timeout: timeOut),
			"Expected 'AdvancedSettingsRobot' screen, but it didn't appear"
		)
	}
	
	// MARK: - Elements
	
	private var localizationSwitch: XCUIElement {
		app.switches["settings.featureflag.localization"]
	}
	
	private var remoteAuthSwitch: XCUIElement {
		app.switches["settings.featureflag.remote_auth"]
	}
	
	private var previousButton: XCUIElement {
		app.buttons["common.previous"]
	}
	
	private var titleLabel: XCUIElement {
		app.navigationBars.staticTexts["Geavanceerd"]
	}

	// MARK: - Validations

	@discardableResult
	func verifyAutomaticLocalizationSwitchExists() -> Self {
		XCTAssertTrue(localizationSwitch.exists)
		return self
	}
	
	@discardableResult
	func verifyPreviousButtonExists() -> Self {
		XCTAssertTrue(previousButton.exists)
		return self
	}
	
	@discardableResult
	func verifyRemoteAuthSwitchExists() -> Self {
		XCTAssertTrue(remoteAuthSwitch.exists)
		return self
	}
	
	// MARK: - Interactions
	
	@discardableResult
	func tapPreviousButton() -> SettingsRobot {
		previousButton.tap()
		return SettingsRobot(app)
	}
}
