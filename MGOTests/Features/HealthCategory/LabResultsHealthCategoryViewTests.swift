/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGO

final class LabResultsHealthCategoryViewTests: AlertsHealthCategoryViewTests {

	@MainActor
	override func createSut(_ categoryId: String) throws {
		
		try super.createSut("lab_results")
	}
}
