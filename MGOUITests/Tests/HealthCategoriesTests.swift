/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class HealthCategoriesTests: XCTestCase {
	
	@MainActor
	func testOverview() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.verifyHeadingExists("Overzicht")
			.verifySubHeadingExists()
			.verifyCategoryExists("Medische klachten")
			.verifyCategoryExists("Uitslagen")
			.verifyCategoryExists("Metingen")
			.verifyCategoryExists("Medicijnen")
			.verifyCategoryExists("Behandelingen")
			.verifyCategoryExists("Afspraken")
			.verifyCategoryExists("Vaccinaties")
			.verifyCategoryExists("Documenten, Geen gegevens")
			.verifyCategoryExists("Allergieën")
			.verifyCategoryExists("Mentaal welzijn")
			.verifyCategoryExists("Leefstijl")
	}
}
