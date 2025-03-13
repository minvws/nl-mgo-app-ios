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
			.verifyCategoryExists("Medicijnen")
			.verifyCategoryExists("Metingen")
			.verifyCategoryExists("Uitslagen")
			.verifyCategoryExists("Allergieën")
			.verifyCategoryExists("Behandelingen")
			.verifyCategoryExists("Afspraken")
			.verifyCategoryExists("Vaccinaties")
			.verifyCategoryExists("Documenten, Geen gegevens")
			.verifyCategoryExists("Medische klachten")
			.verifyCategoryExists("Persoonlijke gegevens")
			.verifyCategoryExists("Mentaal welzijn")
			.verifyCategoryExists("Waarschuwingen")
			.verifyCategoryExists("Leefstijl")
	}
}
