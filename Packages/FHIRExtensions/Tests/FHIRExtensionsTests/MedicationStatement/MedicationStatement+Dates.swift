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
		
		// Then
		expect(startDate) == "2024-02-22"
	}
	
	func test_medicationStatement_dates_2() throws {
		
		// Given
		let json = try getResource("stu3-medication-statement-2")
		let medicationStatement = try Resource.fromJSON(json, type: MedicationStatement.self)
		
		// When
		let startDate = medicationStatement.startDate
		
		// Then
		expect(startDate) == "2024-02-12"
	}
}
