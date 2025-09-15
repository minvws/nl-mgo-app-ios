/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class HealthCategoryTests: XCTestCase {
	
	@MainActor func test_healthCategoryRow() {
		
		// Given
		let row = Generator.healthCategoryRow()
		let otherRow = Generator.healthCategoryRow()
		
		// When
		
		// Then
		expect(row.heading) == otherRow.heading
		expect(row.subHeading) == otherRow.subHeading
		expect(row.id) != otherRow.id
		expect(row) != otherRow
	}
	
	@MainActor func test_healthCategoryBlock() {
		
		// Given
		let subCategory = Generator.healthCategoryBlock()
		let otherSubCategory = Generator.healthCategoryBlock()
		
		// When
		
		// Then
		expect(subCategory.heading) == otherSubCategory.heading
		expect(subCategory.rows) != otherSubCategory.rows
		expect(subCategory.id) != otherSubCategory.id
		expect(subCategory) != otherSubCategory
	}
}
