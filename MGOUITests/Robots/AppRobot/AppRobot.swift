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
	func launchApp(withDemoMode: Bool = false) -> IntroductionRobot {
		app.launchArguments.append("-resetOnStart")
		app.launchArguments.append("-disableTransitions")
		if withDemoMode {
			app.launchArguments.append("-demoMode")
		}
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
	
	/// Launch the application
	/// - Returns: Introduction Robot for the first scene
	@discardableResult
	func launchAppRepeatVisitor() -> HealthCategoriesRobot {
		app.launchArguments.append("-resetOnStart")
		app.launchArguments.append("-disableTransitions")
		app.launchArguments.append("-repeatVisitor")
		app.launch()
		return HealthCategoriesRobot(app)
	}

	/// Launch the app with a Healthcare organization
	/// - Returns: Health Categories Robot for the overview
	@discardableResult
	func navigateToOverview(organization index: Int) -> HealthCategoriesRobot {
		self
			.launchAppRepeatVisitor()
			.verifyAddOrganizationsButtonExists()
			.tapAddOrganizationsButton()
			.enterSearchFields(name: "test", place: "test")
			.tapSearchButton()
			.swipeToListElement(at: index)
			.tapListElement(at: index)
		
		return HealthCategoriesRobot(app)
	}
	
	/// Launch the app without a Healthcare organization
	/// - Returns: Health Categories Robot for the overview
	@discardableResult
	func navigateToOverview() -> HealthCategoriesRobot {
		return self.launchAppRepeatVisitor()
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
}
