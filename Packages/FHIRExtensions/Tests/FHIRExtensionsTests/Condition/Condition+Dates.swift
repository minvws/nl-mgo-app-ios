/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest
import Nimble
@testable import FHIRExtensions

final class ConditionDatesTests: XCTestCase {

	func test_condition_dates_1() throws {
		
		// Given
		let json = try getResource("stu3-condition-1")
		let condition = try Resource.fromJSON(json, type: Condition.self)
		
		// When
		let startDate = condition.startDate
		let endDate = condition.endDate
		
		// Then
		expect(startDate) == "2019-07-14T11:00:00.000+01:00"
		expect(endDate) == nil
	}
	
	func test_condition_dates_2() throws {
		
		// Given
		let json = try getResource("stu3-condition-2")
		let condition = try Resource.fromJSON(json, type: Condition.self)
		
		// When
		let startDate = condition.startDate
		let endDate = condition.endDate
		
		// Then
		expect(startDate) == "2001"
		expect(endDate) == "2002"
	}
}
