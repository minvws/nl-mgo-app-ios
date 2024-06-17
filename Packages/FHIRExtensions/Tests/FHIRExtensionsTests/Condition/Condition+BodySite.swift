/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import FHIRExtensions

final class ConditionBodySiteTests: XCTestCase {

	func test_condition_bodySite_1() throws {
		
		// Given
		let json = try getResource("stu3-condition-1")
		let condition = try Resource.fromJSON(json, type: Condition.self)
		
		// When
		let location = condition.location
		let type = condition.locationType
		
		// Then
		expect(location) == "Heup"
		expect(type) == "Left"
	}
	
	func test_condition_bodySite_2() throws {
		
		// Given
		let json = try getResource("stu3-condition-2")
		let condition = try Resource.fromJSON(json, type: Condition.self)
		
		// When
		let location = condition.location
		let type = condition.locationType
		
		// Then
		expect(location) == "Entire wrist region"
		expect(type) == "Right"
	}
}
