/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest
import Nimble
@testable import FHIRExtensions

final class ConditionCategoryTests: XCTestCase {

	func test_condition_category_1() throws {
		
		// Given
		let json = try getResource("stu3-condition-1")
		let condition = try Resource.fromJSON(json, type: Condition.self)
		
		// When
		let categoryText = condition.categoryText
		
		// Then
		expect(categoryText) == "interpretatie van diagnose (waarneembare entiteit)"
	}
	
	func test_condition_category_2() throws {
		
		// Given
		let json = try getResource("stu3-condition-2")
		let condition = try Resource.fromJSON(json, type: Condition.self)
		
		// When
		let categoryText = condition.categoryText
		
		// Then
		expect(categoryText) == "Complaint"
	}
}
