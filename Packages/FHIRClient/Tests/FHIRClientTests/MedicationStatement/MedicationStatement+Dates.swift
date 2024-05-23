/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest
import Nimble
@testable import FHIRClient

final class MedicationStatementDatesTests: XCTestCase {

	func test_medicationStatement_dates_1() throws {
		
		// Given
		let json = try getResource("stu3-medication-statement-1")
		let medicationStatement = try Resource.fromJSON(json, type: MedicationStatement.self)
		
		// When
		let startDate = medicationStatement.startDate
		let endDate = medicationStatement.endDate
		
		// Then
		expect(startDate) == "22 februari 2024"
		expect(endDate) == nil
	}
	
	func test_medicationStatement_dates_2() throws {
		
		// Given
		let json = try getResource("stu3-medication-statement-2")
		let medicationStatement = try Resource.fromJSON(json, type: MedicationStatement.self)
		
		// When
		let startDate = medicationStatement.startDate
		let endDate = medicationStatement.endDate
		
		// Then
		expect(startDate) == "12 februari 2024"
		expect(endDate) == "26 februari 2024"
	}
}
