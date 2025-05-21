/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import SharedCore

final class FHIRParserTests: XCTestCase {
	
	var sut: FHIRParser!
	
	override func setUp() {
		super.setUp()
		sut = FHIRParser()
	}
	
	func test_version() throws {
		
		// Given
		
		// When
		let result = try sut.getVersion()
		
		// Then
		expect(result.isEmpty) == false
	}
	
	func test_getBundleResourcesJson() throws {
		
		// Given
		let json = try getResource("bundle")
		
		// When
		let result = sut.splitBundleIntoResources(json)
		
		// Then
		expect(result).to(haveCount(2))
	}
	
	func test_getBundleResourcesJson_error() throws {
		
		// Given
		
		// When
		let result = sut.splitBundleIntoResources(Data("wrong".utf8))
		
		// Then
		expect(result).to(beEmpty())
	}
	
	func test_parseResourceJson() throws {
		
		// Given
		let resource = try getStringResource("medicationResource")
		let data = Data(resource.utf8)
		
		// When
		let zib = sut.transformFHIRResourceIntoMGOResource(data)
		
		// Then
		if let zib {
			let zibMedicationUse = ZibFactory.createZibMedicationUse(zib)
			expect(zibMedicationUse?.medicationReference?.display) == "Zestril tablet 10mg"
		} else {
			fail("Could not unwrap zib")
		}
	}
	
	func test_parseResourceJson_explicitFhirVersion() throws {
		
		// Given
		let resource = try getStringResource("medicationResource")
		let data = Data(resource.utf8)
		
		// When
		let zib = sut.transformFHIRResourceIntoMGOResource(data, fhirVersion: "R3")
		
		// Then
		if let zib {
			let zibMedicationUse = ZibFactory.createZibMedicationUse(zib)
			expect(zibMedicationUse?.medicationReference?.display) == "Zestril tablet 10mg"
		} else {
			fail("Could not unwrap zib")
		}
	}
	
	func test_parseResourceJson_wrongFhirVersion() throws {
		
		// Given
		let resource = try getStringResource("medicationResource")
		let data = Data(resource.utf8)
		
		// When
		let zib = sut.transformFHIRResourceIntoMGOResource(data, fhirVersion: "R4")
		
		// Then
		expect(zib) == Data("undefined".utf8)
	}
	
	func test_parseResourceJson_error() throws {
		
		// Given
		
		// When
		let zib = sut.transformFHIRResourceIntoMGOResource(Data("wrong".utf8))
		
		// Then
		expect(zib) == Data("undefined".utf8)
	}
	
	func test_getDetails() throws {
		
		// Given
		let resource = try getStringResource("zibMedicationUse")
		let data = Data(resource.utf8)
		
		// When
		let schema = sut.getDetails(data)
		
		// Then
		expect(schema?.label) == "Paracetamol tablet 500mg"
	}
	
	func test_getDetails_error() throws {
		
		// Given
		
		// When
		let schema = sut.getDetails(Data("wrong".utf8))
		
		// Then
		expect(schema) == nil
	}
	
	func test_getSummary() throws {
		
		// Given
		let resource = try getStringResource("zibMedicationUse")
		let data = Data(resource.utf8)
		
		// When
		let schema = sut.getSummary(data)
		
		// Then
		expect(schema?.label) == "Paracetamol tablet 500mg"
	}
	
	func test_getSummary_error() throws {
		
		// Given
		
		// When
		let schema = sut.getSummary(Data("wrong".utf8))
		
		// Then
		expect(schema) == nil
	}
}
