/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

@MainActor
class AppRobot: Robot {
	
	/// The application to test
	let app: XCUIApplication
	
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
	///   - pincode: the pin code to substitute
	///   - withRemoteAuthentication: True if the remoteAuthentication should be set
	///   - withAutomaticLocalizationEnabled: True if the automatic localization should be enabled
	/// - Returns: Pin code Robot for pin code validation
	@discardableResult
	func launchApp(
		withPincode pincode: String,
		withRemoteAuthentication: Bool = false,
		withAutomaticLocalizationEnabled: Bool = false,
		withDemoMode: Bool = false) -> PincodeRobot {
		
		app.launchArguments.append("-resetOnStart")
		app.launchArguments.append("-disableTransitions")
		app.launchArguments.append("-pincode:\(pincode)")
		if withRemoteAuthentication {
			app.launchArguments.append("-withRemoteAuthentication")
		}
		if withAutomaticLocalizationEnabled {
			app.launchArguments.append("-automaticLocalizationEnabled")
		}
		if withDemoMode {
			app.launchArguments.append("-demoMode")
		}
			
		app.launch()
		return PincodeRobot(app)
	}

	/// Launch the app with a Healthcare organization
	/// - Returns: Health Categories Robot for the overview
	@discardableResult
	func navigateToOverview(organization index: Int) -> HealthCategoriesRobot {
		self
			.navigateToOverview()
			.verifyAddOrganizationsButtonExists()
			.tapAddOrganizationsButton()
			.enterSearchFields(name: "test", place: "test")
			.tapSearchButton()
			.swipeToListElement(at: index)
			.tapListElement(at: index)
		
		return HealthCategoriesRobot(app)
	}
	
	/// Launch the app with a Healthcare organization
	/// - Returns: Health Categories Robot for the overview
	@discardableResult
	func navigateToOverviewWithDigiD(organization index: Int) -> HealthCategoriesRobot {
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
	
	/// Launch the app with a Healthcare organization
	/// - Returns: Health Categories Robot for the overview
	@discardableResult
	func navigateToOverview() -> HealthCategoriesRobot {
		self
			.launchApp(withPincode: "12345", withRemoteAuthentication: true)
			.enterConfirmationPinCodeWithRemoteAuthentication("12345")
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

	/// Launch the app with a BgLZ Healthcare organization
	/// - Returns: Health Categories Robot for the overview
	@discardableResult
	func navigateToOverviewWithLongTermCare() -> HealthCategoriesRobot {
		self.navigateToOverview(organization: 7)
	}
	
	/// Launch the app with a Vaccination Healthcare organization
	/// - Returns: Health Categories Robot for the overview
	@discardableResult
	func navigateToOverviewWithVaccination() -> HealthCategoriesRobot {
		self.navigateToOverview(organization: 8)
	}
	
	/// Enable the biometric face ID login
	/// - Returns: Robot
	@discardableResult func enableFaceID() -> Self {
		
		app.launchArguments.append("-enableFaceID")
		return self
	}
}
