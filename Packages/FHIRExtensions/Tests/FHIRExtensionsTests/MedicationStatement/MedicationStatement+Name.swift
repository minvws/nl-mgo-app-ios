/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import FHIRExtensions

final class MedicationStatementNameTests: XCTestCase {

	func test_medicationStatement_medicationName_1() throws {
		
		// Given
		let json = try getResource("stu3-medication-statement-1")
		let medicationStatement = try Resource.fromJSON(json, type: MedicationStatement.self)
		
		// When
		let name = medicationStatement.medicationName
		
		// Then
		expect(name) == "PARACETAMOL TABLET 500MG"
	}
	
	func test_medicationStatement_medicationName_2() throws {
		
		// Given
		let json = try getResource("stu3-medication-statement-2")
		let medicationStatement = try Resource.fromJSON(json, type: MedicationStatement.self)
		
		// When
		let name = medicationStatement.medicationName
		
		// Then
		expect(name) == "Metoclopramide zetpil 20mg"
	}
}
