/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

@MainActor
final class HealthcareOrganizationsFlowTests: XCTestCase {
	
	/*
	 This e2e test will test the healthcare organizations flow
	 - Verify the existence of the healthcare organizations tab
	 - Verify the existence of the remove healthcare organizations button
	 - Try to remove a healthcare organization, tap the cancel button
	 - Remove a healthcare organization, close the confirmation toast
	 - Remove a healthcare organization, recover via the toast
	 */
	
	private let healthcareOrganizationName = "Kwalificatie Medmij: BGZ"
	
	@MainActor
	func testHealthcareOrganizations_verifyHealthcareOrganizationsOverview() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.tapHealthcareOrganizationTab()
			.verifyHealthcareOrganizationButtonExists(self.healthcareOrganizationName)
			.tapHealthcareOrganizationButton(self.healthcareOrganizationName)
	}
	
	@MainActor
	func testHealthcareOrganizations_navigateToRemoveOrganization() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.tapHealthcareOrganizationTab()
			.tapHealthcareOrganizationButton(self.healthcareOrganizationName)
			.tapMenu()
			.verifyRemoveHealthcareOrganizationButton()
			.tapRemoveHealthcareOrganizationButton()
	}
	
	@MainActor
	func testHealthcareOrganizations_removeOrganizationCancel() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.verifyTitleExists("Overzicht")
			.tapHealthcareOrganizationTab()
			.tapHealthcareOrganizationButton(self.healthcareOrganizationName)
			.verifyHeadingExists(self.healthcareOrganizationName)
			.tapMenu()
			.tapRemoveHealthcareOrganizationButton()
			.verifyCancelButtonExists()
			.verifyRemoveButtonExists()
			.tapCancelButton()
	}
	
	@MainActor
	func testHealthcareOrganizations_removeOrganizationRemoveOrganizationCloseToast() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.verifyTitleExists("Overzicht")
			.tapHealthcareOrganizationTab()
			.tapHealthcareOrganizationButton(self.healthcareOrganizationName)
			.verifyHeadingExists(self.healthcareOrganizationName)
			.tapMenu()
			.tapRemoveHealthcareOrganizationButton()
			.verifyCancelButtonExists()
			.verifyRemoveButtonExists()
			.tapRemoveButton()
			.verifyToastHeadingExists()
			.verifyToastRecoverButtonExists()
			.verifyToastCloseExists()
			.tapToastCloseButton()
	}
	
	@MainActor
	func testHealthcareOrganizations_removeOrganizationRecoverToast() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.verifyTitleExists("Overzicht")
			.tapHealthcareOrganizationTab()
			.tapHealthcareOrganizationButton(self.healthcareOrganizationName)
			.verifyHeadingExists(self.healthcareOrganizationName)
			.tapMenu()
			.tapRemoveHealthcareOrganizationButton()
			.verifyCancelButtonExists()
			.verifyRemoveButtonExists()
			.tapRemoveButton()
			.verifyToastHeadingExists()
			.verifyToastRecoverButtonExists()
			.verifyToastCloseExists()
			.tapToastRecoverButton()
			.verifyHeadingExists(self.healthcareOrganizationName)
	}
}
