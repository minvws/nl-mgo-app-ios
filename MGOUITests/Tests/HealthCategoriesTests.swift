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
			.startWithBGZ()
			.verifyHeading("Overzicht")
			.verifySubHeading()
			.verifyCategory("Medicijnen")
			.verifyCategory("Metingen")
			.verifyCategory("Uitslagen")
			.verifyCategory("Allergieën")
			.verifyCategory("Behandelingen")
			.verifyCategory("Afspraken")
			.verifyCategory("Vaccinaties")
			.verifyCategory("Documenten, Geen gegevens")
			.verifyCategory("Medische klachten")
			.verifyCategory("Persoonlijke gegevens")
			.verifyCategory("Mentaal welzijn")
			.verifyCategory("Waarschuwingen")
			.verifyCategory("Leefstijl")
	}
}
