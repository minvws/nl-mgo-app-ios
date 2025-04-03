/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class OrganizationsTests: XCTestCase {
	
	@MainActor
	func testOrganizationsOverview() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.tapHealthcareProviderTab()
			.verifyHealthcareProviderButtonExists("Kwalificatie Medmij: BGZ")
			.tapHealthcareProviderButton("Kwalificatie Medmij: BGZ")
	}
}
