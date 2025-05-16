/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class AboutSafetyTipsRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an About Safety Tips Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application
		XCTAssertTrue(
			titleLabel.waitForExistence(timeout: timeOut),
			"Expected 'AboutSafetyTipsRobot' screen, but it didn't appear"
		)
	}
	
	// MARK: - Elements

	private var previousButton: XCUIElement {
		app.buttons["common.previous"]
	}
	
	private var titleLabel: XCUIElement {
		app.navigationBars.staticTexts["Veilig gebruik"]
	}
	
	private var subHeadingLabel: XCUIElement {
		app.staticTexts["settings.about_this_app.safety.subheading"]
	}
	
	// MARK: - Validations
	
	@discardableResult
	func verifyPreviousButtonExists() -> Self {
		XCTAssertTrue(previousButton.exists)
		return self
	}

	@discardableResult
	func verifySubHeadingExists() -> Self {
		XCTAssertTrue(subHeadingLabel.exists)
		return self
	}
	
	@discardableResult
	func verifySafetyTipsHeadingExists(_ heading: String) -> Self {
		XCTAssertTrue(app.staticTexts[heading].exists)
		return self
	}
	
	@discardableResult
	func verifySafetyTipsSubHeadingExists(_ subheading: String) -> Self {
		XCTAssertTrue(app.staticTexts[subheading].exists)
		return self
	}
	
	@discardableResult
	func verifySafetyTips() -> Self {
		self
			.verifySafetyTipsHeadingExists("settings.about_this_app_safety.security_phone.heading")
			.verifySafetyTipsSubHeadingExists("settings.about_this_app_safety.security_phone.subheading")
			.verifySafetyTipsHeadingExists("settings.about_this_app_safety.phone_yourself.heading")
			.verifySafetyTipsSubHeadingExists("settings.about_this_app_safety.phone_yourself.subheading")
			.verifySafetyTipsHeadingExists("settings.about_this_app_safety.install_updates.heading")
			.verifySafetyTipsSubHeadingExists("settings.about_this_app_safety.install_updates.subheading")
			.verifySafetyTipsHeadingExists("settings.about_this_app_safety.safe_apps.heading")
			.verifySafetyTipsSubHeadingExists("settings.about_this_app_safety.safe_apps.subheading")
			.verifySafetyTipsHeadingExists("settings.about_this_app_safety.public_wifi.heading")
			.verifySafetyTipsSubHeadingExists("settings.about_this_app_safety.public_wifi.subheading")
		return self
	}
	
	// MARK: - Interactions
	
	@discardableResult
	func tapPreviousButton() -> AboutTheAppRobot {
		previousButton.tap()
		return AboutTheAppRobot(app)
	}
}
