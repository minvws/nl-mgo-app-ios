/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class DisplaySettingsRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an Display Settings Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application
		XCTAssertTrue(
			titleLabel.waitForExistence(timeout: timeOut),
			"Expected 'DisplaySettingsRobot' screen, but it didn't appear"
		)
	}
	
	// MARK: - Elements
	
	private var lightButton: XCUIElement {
		app.buttons["settings.display.light"]
	}
	
	private var darkButton: XCUIElement {
		app.buttons["settings.display.dark"]
	}
	
	private var systemButton: XCUIElement {
		app.buttons["settings.display.system"]
	}

	private var previousButton: XCUIElement {
		app.buttons["common.previous"]
	}
	
	private var titleLabel: XCUIElement {
		app.navigationBars.staticTexts["Weergave"]
	}

	// MARK: - Validations
	
	@discardableResult
	func verifyDarkButtonExists() -> Self {
		XCTAssertTrue(darkButton.exists)
		return self
	}
	
	@discardableResult
	func verifyLightButtonExists() -> Self {
		XCTAssertTrue(lightButton.exists)
		return self
	}
	
	@discardableResult
	func verifySystemButtonExists() -> Self {
		XCTAssertTrue(systemButton.exists)
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
	
	@discardableResult
	func tapDarkButton() -> Self {
		darkButton.tap()
		return self
	}
	
	@discardableResult
	func tapLightButton() -> Self {
		lightButton.tap()
		return self
	}
	
	@discardableResult
	func tapSystemButton() -> Self {
		systemButton.tap()
		return self
	}
}
