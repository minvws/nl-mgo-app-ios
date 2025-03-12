/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class AppRobot: Robot {
	
	/// The application to test
	var app: XCUIApplication
	
	/// Create the app robot
	init() {
		app = XCUIApplication()
	}
	
	/// Launch the application
	/// - Returns: Introduction Robot for the first scene
	@discardableResult
	func launchApp() -> IntroductionRobot {
		app.launchArguments.append("-resetOnStart")
		app.launchArguments.append("-disableTransitions")
		app.launch()
		return IntroductionRobot(app)
	}
	
	/// Launch the application
	/// - Returns: Introduction Robot for the first scene
	@discardableResult
	func launchAppUpdateRequired() -> UpdateRequiredRobot {
		app.launchArguments.append("-resetOnStart")
		app.launchArguments.append("-disableTransitions")
		app.launchArguments.append("-updateRequired")
		app.launch()
		return UpdateRequiredRobot(app)
	}
	
	func launchApp(withPincode pincode: String, withRemoteAuthentication: Bool = false) -> PincodeRobot {
		app.launchArguments.append("-resetOnStart")
		app.launchArguments.append("-disableTransitions")
		app.launchArguments.append("-pincode:\(pincode)")
		if withRemoteAuthentication {
			app.launchArguments.append("-withRemoteAuthentication")
		}
		app.launch()
		return PincodeRobot(app)
	}
	
	func startWithBGZ() -> HealthCategoriesRobot {
		self
			.launchApp(withPincode: "12345")
			.enterConfirmationPinCode("12345")
			.tapDigiDButton()
			.verifySafariIsOpen()
			.verifyMockDigiDSubmitButton()
			.tapMockDigiDSubmitButton()
			.enterBasicAuthorizationIfNeeded()
			.verifyOpenButton()
			.tapOpenButton()
			.enterSearchFields(name: "test", place: "test")
			.tapSearchButton()
			.tapListElement(at: 4)
		
		return HealthCategoriesRobot(app)
	}
}
