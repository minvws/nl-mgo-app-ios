/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import FHIRExtensions

final class PatientEmailTests: XCTestCase {

	func test_patient_getEmail_1() throws {
		
		// Given
		let json = try getResource("stu3-patient-telecom-1")
		let patient = try Resource.fromJSON(json, type: Patient.self)
		
		// When
		let email = patient.email
		
		// Then
		expect(email) == "current@hotmail.com"
	}
	
	func test_patient_getEmail_2() throws {
		
		// Given
		let json = try getResource("stu3-patient-telecom-2")
		let patient = try Resource.fromJSON(json, type: Patient.self)
		
		// When
		let email = patient.email
		
		// Then
		expect(email) == "user@home.nl"
	}
	
	func test_patient_getEmail_3() throws {
		
		// Given
		let json = try getResource("stu3-patient-telecom-3")
		let patient = try Resource.fromJSON(json, type: Patient.self)
		
		// When
		let email = patient.email
		
		// Then
		expect(email) == "XXX_Helleman@work.nl"
	}
	
	func test_patient_getEmail_4() throws {
		
		// Given
		let json = try getResource("stu3-patient-telecom-4")
		let patient = try Resource.fromJSON(json, type: Patient.self)
		
		// When
		let email = patient.email
		
		// Then
		expect(email) == nil
	}
}
