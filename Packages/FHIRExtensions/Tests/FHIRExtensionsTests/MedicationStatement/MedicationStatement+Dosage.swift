/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import FHIRExtensions

final class MedicationStatementDosageTests: XCTestCase {

	func test_medicationStatement_dosage_1() throws {
		
		// Given
		let json = try getResource("stu3-medication-statement-1")
		let medicationStatement = try Resource.fromJSON(json, type: MedicationStatement.self)
		
		// When
		let dosage = medicationStatement.dosageText
		
		// Then
		expect(dosage) == "Vanaf 22 februari 2024, gedurende 30 dagen, zo nodig maal per dag 1 à 2 stuks , maximaal 6 stuks per dag, oraal"
	}
	
	func test_medicationStatement_dosage_2() throws {
		
		// Given
		let json = try getResource("stu3-medication-statement-2")
		let medicationStatement = try Resource.fromJSON(json, type: MedicationStatement.self)
		
		// When
		let dosage = medicationStatement.dosageText
		
		// Then
		expect(dosage) == "Vanaf 12 februari 2024, gedurende 14 dagen, bij koorts per dag 1 stuks, maximaal 2 stuks per dag, rectaal"
	}
}
