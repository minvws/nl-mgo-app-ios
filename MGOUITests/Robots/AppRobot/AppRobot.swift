/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
	
	/// Launch the app as a repeat visitor
	/// - Parameters:
	///   - pincode: the pincode to substitute
	///   - withRemoteAuthentication: True if the remoteAuthentication should be set
	/// - Returns: Pincode Robot for pincode validation
	@discardableResult
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

	/// Launch the app with a Healthcare organization
	/// - Returns: Health Categories Robot for the overview
	@discardableResult
	func navigateToOverview(organization index: Int) -> HealthCategoriesRobot {
		self
			.launchApp(withPincode: "12345")
			.enterConfirmationPinCode("12345")
			.tapLoginWithDigiDButton()
			.performCompleteDigiDLogin()
			.enterSearchFields(name: "test", place: "test")
			.tapSearchButton()
			.swipeToListElement(at: index)
			.tapListElement(at: index)
		
		return HealthCategoriesRobot(app)
	}
	
	/// Launch the app with a BGZ Healthcare organization
	/// - Returns: Health Categories Robot for the overview
	@discardableResult
	func navigateToOverviewWithBGZ() -> HealthCategoriesRobot {
		self.navigateToOverview(organization: 4)
	}
	
	/// Launch the app with a GP Healthcare organization
	/// - Returns: Health Categories Robot for the overview
	@discardableResult
	func navigateToOverviewWithGP() -> HealthCategoriesRobot {
		self.navigateToOverview(organization: 5)
	}
	
	/// Launch the app with a Document (PDFA) Healthcare organization
	/// - Returns: Health Categories Robot for the overview
	@discardableResult
	func navigateToOverviewWithPDFA() -> HealthCategoriesRobot {
		self.navigateToOverview(organization: 6)
	}
	
	/// Launch the app with a Vaccination Healthcare organization
	/// - Returns: Health Categories Robot for the overview
	@discardableResult
	func navigateToOverviewWithVaccination() -> HealthCategoriesRobot {
		self.navigateToOverview(organization: 7)
	}
	
	/// Enable the biometric face ID login
	/// - Returns: Robot
	@discardableResult func enableFaceID() -> Self {
		
		app.launchArguments.append("-enableFaceID")
		return self
	}
}
