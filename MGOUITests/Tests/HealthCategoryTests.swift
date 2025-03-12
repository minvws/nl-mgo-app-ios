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
			.startWithBGZ()
			.tapCategory("Medicijnen")
			.verifyHeading("Medicijnen")
			.verifySection("Medicijnen die je gebruikt")
			.verifyButton(0, section: 0)
			.verifySection("Afspraken over je medicijnen")
			.verifyButton(0, section: 1)
			.verifySection("Hoe je je medicijnen krijgt")
			.verifyButton(0, section: 2)
			.tapElement(0, section: 0)
	}
}
