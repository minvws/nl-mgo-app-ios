/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

final class HealthcareOrganizationsFlowTests: XCTestCase {
	
	/*
	 This e2e test will test the healthcare organizations flow
	 - Verify the existence of the healthcare organizations tab
	 - Verify the existence of the remove healthcare organizations button
	 - Try to remove a healthcare organization, tap the cancel button
	 - Try to remove a healthcare organization, close the sheet
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
	
	func testHealthcareOrganizations_navigateToRemoveOrganization() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.verifyTitleExists("Overzicht")
			.tapHealthcareOrganizationTab()
			.tapHealthcareOrganizationButton("Kwalificatie Medmij: BGZ")
			.verifyHeadingExists("Kwalificatie Medmij: BGZ")
			.verifySubHeadingExists()
			.verifyCategoryExists("Medische klachten")
			.swipeToRemoveHealthcareOrganizationButton()
			.verifyRemoveHealthcareOrganizationButton()
	}
	
	@MainActor
	func testHealthcareOrganizations_removeOrganizationCancel() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.verifyTitleExists("Overzicht")
			.tapHealthcareOrganizationTab()
			.tapHealthcareOrganizationButton(self.healthcareOrganizationName)
			.verifyHeadingExists(self.healthcareOrganizationName)
			.swipeToRemoveHealthcareOrganizationButton()
			.tapRemoveHealthcareOrganizationButton()
			.verifySubHeadingExists()
			.verifyCloseButtonExists()
			.verifyCancelButtonExists()
			.verifyRemoveButtonExists()
			.tapCancelButton()
	}
	
	@MainActor
	func testHealthcareOrganizations_removeOrganizationCloseSheet() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.verifyTitleExists("Overzicht")
			.tapHealthcareOrganizationTab()
			.tapHealthcareOrganizationButton(self.healthcareOrganizationName)
			.verifyHeadingExists(self.healthcareOrganizationName)
			.swipeToRemoveHealthcareOrganizationButton()
			.tapRemoveHealthcareOrganizationButton()
			.verifySubHeadingExists()
			.verifyCloseButtonExists()
			.verifyCancelButtonExists()
			.verifyRemoveButtonExists()
			.tapCloseButton()
	}
	
	@MainActor
	func testHealthcareOrganizations_removeOrganizationRemoveOrganizationCloseToast() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.verifyTitleExists("Overzicht")
			.tapHealthcareOrganizationTab()
			.tapHealthcareOrganizationButton(self.healthcareOrganizationName)
			.verifyHeadingExists(self.healthcareOrganizationName)
			.swipeToRemoveHealthcareOrganizationButton()
			.tapRemoveHealthcareOrganizationButton()
			.verifySubHeadingExists()
			.verifyCloseButtonExists()
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
			.swipeToRemoveHealthcareOrganizationButton()
			.tapRemoveHealthcareOrganizationButton()
			.verifySubHeadingExists()
			.verifyCloseButtonExists()
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
