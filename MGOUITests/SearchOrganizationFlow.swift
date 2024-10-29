/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest

final class SearchOrganizationFlow: BaseFlowTest {
	
	override func setUpWithError() throws {
		
		app.launchArguments.append("-skipOnboarding")
		app.launchArguments.append("-pincode:12345")
		try super.setUpWithError()
	}
	
	func test_searchOrganizationFlow() {
		
		// Local Authentication
		enterPinCode("12345")
		
		// Remote Authentication
		app.buttons["login.digid"].tap()
		
		assertOverviewNoOrganizationsScreen()
		
		// Navigate to Add Organization
		app.buttons["overview.add_organization"].tap()
		
		assertAddOrganizationScreen()
		
		// Enter search criteria
		app.typeText("add_organization.name", text: "Tandarts")
		app.typeText("add_organization.city", text: "Breda")
		app.buttons["common.search"].tap()
		
		assertOrganizationSearchResultsScreen()
		
		// Tap first result
		app.buttons["organization_search.result_1"].tap()

		assertOverviewWithOrganizationsScreen()
	}
}

// MARK: - Assertions -

extension BaseFlowTest {
	
	/// Are we on the Overview screen in the no organizations state?
	func assertOverviewNoOrganizationsScreen() {
		
		app.textExists("overview.heading")
		app.textNotExists("overview.subheading")
		app.textExists("overview.no_organizations_found")
	}
	
	/// Are we on the Overview screen?
	func assertOverviewWithOrganizationsScreen() {
		
		app.textExists("overview.heading")
		app.textExists("overview.subheading")
		app.textNotExists("overview.no_organizations_found")
	}
	
	/// Are we on the Add Organization screen?
	func assertAddOrganizationScreen() {
		
		app.textExists("add_organization.heading")
	}
	
	/// Are we on the search results screen?
	func assertOrganizationSearchResultsScreen() {
		
		app.textExists("organization_search.heading")
	}
}
