/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import XCTest
import Nimble

final class MedicationUseDecoratorTests: XCTestCase {
	
	func test_decorator() throws {
		
		// Given
		let medicationStatement = MockGenerator.medicationStatement()
		let expectedMedicationUse = MgoMedicationUse(
			title: "PARACETAMOL TABLET 500MG",
			instructions: "Vanaf 22 februari 2024, gedurende 30 dagen, zo nodig maal per dag 1 à 2 stuks , maximaal 6 stuks per dag, oraal",
			prescribedBy: nil,
			startDate: "2024-02-21",
			status: "active"
		)
		
		// When
		let actualMedicationUse = MedicationUseDecorator.create(medicationStatement)
		
		// Then
		expect(expectedMedicationUse) == actualMedicationUse
	}
}
