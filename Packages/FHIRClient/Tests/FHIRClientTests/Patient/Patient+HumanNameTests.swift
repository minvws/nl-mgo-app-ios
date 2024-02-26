/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest
import Nimble
@testable import FHIRClient

final class PatientHumanNameTests: XCTestCase {

	func test_patient_getHumanName_1() throws {
		
		// Given
		let json = try getResource("stu3-patient-name-1")
		let patient = try Patient(json: json)
		
		// When
		let name = patient.humanName
		
		// Then
		expect(name) == "Jim"
	}
	
	func test_patient_getHumanName_2() throws {
		
		// Given
		let json = try getResource("stu3-patient-name-2")
		let patient = try Patient(json: json)
		
		// When
		let name = patient.humanName
		
		// Then
		expect(name) == "Dr. phil. Regina Johanna Maria von Hochheim-Weilenfels NCFSA"
	}
	
	func test_patient_getHumanName_3() throws {
		
		// Given
		let json = try getResource("stu3-patient-name-3")
		let patient = try Patient(json: json)
		
		// When
		let name = patient.humanName
		
		// Then
		expect(name) == "Johan XXX_Helleman"
	}
	
	func test_patient_getHumanName_4() throws {
		
		// Given
		let json = try getResource("stu3-patient-name-4")
		let patient = try Patient(json: json)
		
		// When
		let name = patient.humanName
		
		// Then
		expect(name) == "Karin Berg"
	}
}
