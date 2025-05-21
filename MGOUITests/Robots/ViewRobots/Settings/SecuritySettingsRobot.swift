/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class SecuritySettingsRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an Security Settings Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application
		XCTAssertTrue(
			titleLabel.waitForExistence(timeout: timeOut),
			"Expected 'SecuritySettingsRobot' screen, but it didn't appear"
		)
	}
	
	// MARK: - Elements
	
	private var biometricSwitch: XCUIElement {
		app.switches["settings.security.toggle"]
	}
	
	private var previousButton: XCUIElement {
		app.buttons["common.previous"]
	}
	
	private var titleLabel: XCUIElement {
		app.navigationBars.staticTexts["Beveiliging"]
	}

	// MARK: - Validations

	@discardableResult
	func verifyBiometricSwitchExists() -> Self {
		XCTAssertTrue(biometricSwitch.exists)
		return self
	}
	
	@discardableResult
	func verifyPreviousButtonExists() -> Self {
		XCTAssertTrue(previousButton.exists)
		return self
	}
	
	// MARK: - Interactions
	
	@discardableResult
	func tapPreviousButton() -> SettingsRobot {
		previousButton.tap()
		return SettingsRobot(app)
	}
}
