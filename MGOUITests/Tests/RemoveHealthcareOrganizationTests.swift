/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class RemoveHealthcareOrganizationTests: XCTestCase {
	
	@MainActor
	func testRemoveProviderCancel() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.verifyTitleExists("Overzicht")
			.tapHealthcareProviderTab()
			.tapHealthcareProviderButton("Kwalificatie Medmij: BGZ")
			.verifyHeadingExists("Kwalificatie Medmij: BGZ")
			.swipeToRemoveHealthcareOrganizationButton()
			.tapRemoveHealthcareOrganizationButton()
			.verifySubHeadingExists()
			.verifyCloseButtonExists()
			.verifyCancelButtonExists()
			.verifyRemoveButtonExists()
			.tapCancelButton()
	}
	
	@MainActor
	func testRemoveProviderCloseSheet() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.verifyTitleExists("Overzicht")
			.tapHealthcareProviderTab()
			.tapHealthcareProviderButton("Kwalificatie Medmij: BGZ")
			.verifyHeadingExists("Kwalificatie Medmij: BGZ")
			.swipeToRemoveHealthcareOrganizationButton()
			.tapRemoveHealthcareOrganizationButton()
			.verifySubHeadingExists()
			.verifyCloseButtonExists()
			.verifyCancelButtonExists()
			.verifyRemoveButtonExists()
			.tapCloseButton()
	}
	
	@MainActor
	func testRemoveProviderRemoveProviderCloseToast() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.verifyTitleExists("Overzicht")
			.tapHealthcareProviderTab()
			.tapHealthcareProviderButton("Kwalificatie Medmij: BGZ")
			.verifyHeadingExists("Kwalificatie Medmij: BGZ")
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
	func testRemoveProviderRemoveProviderRecoverToast() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.verifyTitleExists("Overzicht")
			.tapHealthcareProviderTab()
			.tapHealthcareProviderButton("Kwalificatie Medmij: BGZ")
			.verifyHeadingExists("Kwalificatie Medmij: BGZ")
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
			.verifyHeadingExists("Kwalificatie Medmij: BGZ")
	}
}
