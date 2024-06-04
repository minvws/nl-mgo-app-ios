/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest
import Nimble
@testable import FHIRExtensions

final class MedicationStatementPrescriberTests: XCTestCase {

	func test_medicationStatement_prescriber_empty() throws {
		
		// Given
		let json = try getResource("stu3-medication-statement-1")
		let medicationStatement = try Resource.fromJSON(json, type: MedicationStatement.self)
		
		// When
		let name = medicationStatement.prescriber
		
		// Then
		expect(name) == nil
	}
	
	func test_medicationStatement_prescriber() throws {
		
		// Given
		let json = try getResource("stu3-medication-statement-2")
		let medicationStatement = try Resource.fromJSON(json, type: MedicationStatement.self)
		
		// When
		let name = medicationStatement.prescriber
		
		// Then
		expect(name) == "Orthopedie - UMCG"
	}
}
