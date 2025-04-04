/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

final class HealthcareProvidersFlowTests: XCTestCase {
	
	/*
	 This e2e test will test the healthcare providers flow
	 - Verify the existence of the healthcare providers tab
	 - Verify the existence of the remove healthcare provider button
	 - Try to remove a healthcare provider, tap the cancel button
	 - Try to remove a healthcare provider, close the sheet
	 - Remove a healthcare provider, close the confirmation toast
	 - Remove a healthcare provider, recover via the toast
	 */
	
	private let healthcareProviderName = "Kwalificatie Medmij: BGZ"
	
	@MainActor
	func testHealthcareProviders_verifyHealthcareProvidersOverview() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.tapHealthcareProviderTab()
			.verifyHealthcareProviderButtonExists(self.healthcareProviderName)
			.tapHealthcareProviderButton(self.healthcareProviderName)
	}
	
	func testHealthcareProviders_navigateToRemoveProvider() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.verifyTitleExists("Overzicht")
			.tapHealthcareProviderTab()
			.tapHealthcareProviderButton("Kwalificatie Medmij: BGZ")
			.verifyHeadingExists("Kwalificatie Medmij: BGZ")
			.verifySubHeadingExists()
			.verifyCategoryExists("Medische klachten")
			.swipeToRemoveHealthcareOrganizationButton()
			.verifyRemoveHealthcareOrganizationButton()
	}
	
	@MainActor
	func testHealthcareProviders_removeProviderCancel() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.verifyTitleExists("Overzicht")
			.tapHealthcareProviderTab()
			.tapHealthcareProviderButton(self.healthcareProviderName)
			.verifyHeadingExists(self.healthcareProviderName)
			.swipeToRemoveHealthcareOrganizationButton()
			.tapRemoveHealthcareOrganizationButton()
			.verifySubHeadingExists()
			.verifyCloseButtonExists()
			.verifyCancelButtonExists()
			.verifyRemoveButtonExists()
			.tapCancelButton()
	}
	
	@MainActor
	func testHealthcareProviders_removeProviderCloseSheet() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.verifyTitleExists("Overzicht")
			.tapHealthcareProviderTab()
			.tapHealthcareProviderButton(self.healthcareProviderName)
			.verifyHeadingExists(self.healthcareProviderName)
			.swipeToRemoveHealthcareOrganizationButton()
			.tapRemoveHealthcareOrganizationButton()
			.verifySubHeadingExists()
			.verifyCloseButtonExists()
			.verifyCancelButtonExists()
			.verifyRemoveButtonExists()
			.tapCloseButton()
	}
	
	@MainActor
	func testHealthcareProviders_removeProviderRemoveProviderCloseToast() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.verifyTitleExists("Overzicht")
			.tapHealthcareProviderTab()
			.tapHealthcareProviderButton(self.healthcareProviderName)
			.verifyHeadingExists(self.healthcareProviderName)
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
	func testHealthcareProviders_removeProviderRecoverToast() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.verifyTitleExists("Overzicht")
			.tapHealthcareProviderTab()
			.tapHealthcareProviderButton(self.healthcareProviderName)
			.verifyHeadingExists(self.healthcareProviderName)
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
			.verifyHeadingExists(self.healthcareProviderName)
	}
}
