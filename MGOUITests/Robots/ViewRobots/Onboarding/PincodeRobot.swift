/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class PincodeRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an Pincode Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		
		self.app = application
		XCTAssertTrue(
			titleLabel.waitForExistence(timeout: timeOut),
			"Expected 'PincodeRobot' screen, but it didn't appear"
		)
	}
	
	// MARK: - Elements
	
	private var titleLabel: XCUIElement {
		app.staticTexts["pincode.heading"]
	}
	
	private func subHeading(_ subHeading: String) -> XCUIElement {
		app.staticTexts[subHeading]
	}
	
	private func errorText(_ error: String) -> XCUIElement {
		app.staticTexts[error]
	}
	
	private var forgotButton: XCUIElement {
		app.buttons["pincode.forgot"]
	}

	// MARK: - Validations
	
	@discardableResult
	func verifySubHeadingExists(_ label: String) -> Self {
		XCTAssertTrue(subHeading(label).exists)
		return self
	}
	
	@discardableResult
	func verifyErrorTextExists(_ error: String) -> Self {
		XCTAssertTrue(errorText(error).exists)
		return self
	}
	
	@discardableResult
	func verifyForgotButtonExists() -> Self {
		XCTAssertTrue(forgotButton.exists)
		return self
	}
	
	// MARK: - Interactions
	
	@discardableResult
	func enterPinCode(_ code: String) -> Self {
		for element in Array(code) {
			app.buttons[String(element)].tap()
		}
		return self
	}
	
	@discardableResult
	func enterConfirmationPinCode(_ code: String) -> LoginRobot {
		enterPinCode(code)
		return LoginRobot(app)
	}
	
	@discardableResult
	func enterConfirmationPinCodeWithBioMetric(_ code: String) -> BioMetricSetupRobot {
		enterPinCode(code)
		return BioMetricSetupRobot(app)
	}
	
	@discardableResult
	func enterConfirmationPinCodeWithRemoteAuthentication(_ code: String) -> AddOrganizationRobot {
		enterPinCode(code)
		return AddOrganizationRobot(app)
	}
	
	@discardableResult
	func enterConfirmationPinCodeWithSettings(_ code: String) -> SettingsRobot {
		enterPinCode(code)
		return SettingsRobot(app)
	}
	
	@discardableResult
	func tapForgotButton() -> ForgotPincodeRobot {
		forgotButton.tap()
		return ForgotPincodeRobot(app)
	}
}
