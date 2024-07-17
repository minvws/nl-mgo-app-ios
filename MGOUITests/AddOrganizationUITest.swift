/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest

final class AddOrganizationUITests: BaseUITest {
	
	override func setUpWithError() throws {
		
		app.launchArguments.append("-skipOnboarding")
		app.launchArguments.append("-pincode:12345")
		try super.setUpWithError()
	}
	
	private func enterPinCode(code: [String]) {
		
		for element in code {
			app.buttons[element].tap()
		}
	}
	
	func test_addOrganization() {
		
		// Local Authentication
		enterPinCode(code: ["1", "2", "3", "4", "5"])
		
		// Remote Authentication
		app.buttons["login.digid"].tap()
		
		// Assert Overview
		app.textExists("overview.heading")
		app.textNotExists("overview.subheading")
		app.textExists("overview.no_organizations_found")
		
		// Navigate to Add Organization
		app.buttons["overview.add_organizations"].tap()
		
		// Assert Add Organization
		app.textExists("add_organization.heading")
		
		// Enter search criteria
		app.typeText("add_organization.name", text: "Tandarts")
		app.typeText("add_organization.city", text: "Breda")
		app.buttons["common.search"].tap()
		
		// Assert Search results
		app.textExists("organization_search.heading")
		
		// Tap first result
		app.buttons["organization_search.result_1"].tap()

		// Assert Overview
		app.textExists("overview.heading")
		app.textExists("overview.subheading")
		app.textNotExists("overview.no_organizations_found")
	}
}
