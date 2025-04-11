/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class HealthCategoryTests: XCTestCase {
	
	func test_healthCategoryRow() {
		
		// Given
		let row = HealthCategoryRow(heading: "heading", subHeading: "healthcare organization", action: nil)
		let otherRow = HealthCategoryRow(heading: "heading", subHeading: "healthcare organization", action: nil)
		
		// When
		
		// Then
		expect(row.heading) == otherRow.heading
		expect(row.subHeading) == otherRow.subHeading
		expect(row.id) != otherRow.id
		expect(row) != otherRow
	}
	
	func test_healthSubCategory() {
		
		// Given
		let subCategory = HealthSubCategory(
			heading: "heading subcategory",
			rows: [
				HealthCategoryRow(heading: "heading", subHeading: "healthcare organization", action: nil)
			]
		)
		let otherSubCategory = HealthSubCategory(
			heading: "heading subcategory",
			rows: [
				HealthCategoryRow(heading: "heading", subHeading: "healthcare organization", action: nil)
			]
		)
		
		// When
		
		// Then
		expect(subCategory.heading) == otherSubCategory.heading
		expect(subCategory.rows) != otherSubCategory.rows
		expect(subCategory.id) != otherSubCategory.id
		expect(subCategory) != otherSubCategory
	}
}
