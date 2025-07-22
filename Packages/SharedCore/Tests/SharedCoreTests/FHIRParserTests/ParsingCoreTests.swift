/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import SharedCore

final class FHIRParserTests: XCTestCase {
	
	var sut: HCIMParser!
	
	override func setUp() {
		super.setUp()
		sut = HCIMParser()
	}
	
	@MainActor func test_version() throws {
		
		// Given
		
		// When
		let result = try sut.getVersion()
		
		// Then
		expect(result.isEmpty) == false
	}
	
	@MainActor func test_getBundleResourcesJson() throws {
		
		// Given
		let json = try getResource("bundle")
		
		// When
		let result = sut.splitBundleIntoResources(json)
		
		// Then
		expect(result).to(haveCount(2))
	}
	
	@MainActor func test_getBundleResourcesJson_error() throws {
		
		// Given
		
		// When
		let result = sut.splitBundleIntoResources(Data("wrong".utf8))
		
		// Then
		expect(result).to(beEmpty())
	}
	
	@MainActor func test_parseResourceJson() throws {
		
		// Given
		let resource = try getStringResource("medicationResource")
		let data = Data(resource.utf8)
		
		// When
		let zib = sut.transformFHIRResourceIntoHCIM(data)
		
		// Then
		if let zib {
			let zibMedicationUse = HCIMFactory.createZibMedicationUse(zib)
			expect(zibMedicationUse?.medicationReference?.display) == "Zestril tablet 10mg"
		} else {
			fail("Could not unwrap zib")
		}
	}
	
	@MainActor func test_parseResourceJson_explicitFhirVersion() throws {
		
		// Given
		let resource = try getStringResource("medicationResource")
		let data = Data(resource.utf8)
		
		// When
		let zib = sut.transformFHIRResourceIntoHCIM(data, fhirVersion: "R3")
		
		// Then
		if let zib {
			let zibMedicationUse = HCIMFactory.createZibMedicationUse(zib)
			expect(zibMedicationUse?.medicationReference?.display) == "Zestril tablet 10mg"
		} else {
			fail("Could not unwrap zib")
		}
	}
	
	@MainActor func test_parseResourceJson_wrongFhirVersion() throws {
		
		// Given
		let resource = try getStringResource("medicationResource")
		let data = Data(resource.utf8)
		
		// When
		let zib = sut.transformFHIRResourceIntoHCIM(data, fhirVersion: "R4")
		
		// Then
		expect(zib) == Data("null".utf8)
	}
	
	@MainActor func test_parseResourceJson_error() throws {
		
		// Given
		
		// When
		let zib = sut.transformFHIRResourceIntoHCIM(Data("wrong".utf8))
		
		// Then
		expect(zib) == Data("undefined".utf8)
	}
	
	@MainActor func test_getDetails() throws {
		
		// Given
		let resource = try getStringResource("zibMedicationUse")
		let data = Data(resource.utf8)
		
		// When
		let schema = sut.getDetails(data)
		
		// Then
		expect(schema?.label) == "Medicatiegebruik"
	}
	
	@MainActor func test_getDetails_error_shouldReturnNil() throws {
		
		// Given
		
		// When
		let schema = sut.getDetails(Data("wrong".utf8))
		
		// Then
		expect(schema) == nil
	}
	
	@MainActor func test_getSummary() throws {
		
		// Given
		let resource = try getStringResource("zibMedicationUse")
		let data = Data(resource.utf8)
		
		// When
		let schema = sut.getSummary(data)
		
		// Then
		expect(schema?.label) == "Paracetamol tablet 500mg"
	}
	
	@MainActor func test_getSummary_error_shouldReturnNil() throws {
		
		// Given
		
		// When
		let schema = sut.getSummary(Data("wrong".utf8))
		
		// Then
		expect(schema) == nil
	}
}
