/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class HealthCategoryTests: XCTestCase {
	
	@MainActor
	func testMedicationCategory() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.tapHealthCategory("Medicijnen")
			.verifyHeadingExists("Medicijnen")
			.verifySectionExists("Medicijnen die je gebruikt")
			.verifySectionButtonExists(0, section: 0)
			.verifySectionExists("Afspraken over je medicijnen")
			.verifySectionButtonExists(0, section: 1)
			.verifySectionExists("Hoe je je medicijnen krijgt")
			.verifySectionButtonExists(0, section: 2)
			.tapSectionRow(0, section: 0)
	}
}
