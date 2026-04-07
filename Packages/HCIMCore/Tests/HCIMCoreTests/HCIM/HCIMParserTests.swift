/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import HCIMCore
import Foundation
import Testing

@MainActor
struct HCIMParserTests {
	
	/// Subject under test
	var sut: HCIMParser!
	
	/// setup
	init() {
		sut = HCIMParser()
	}
	
	@Test func getVersion() throws {
		
		// Given
		
		// When
		let result = try sut.getVersion()
		
		// Then
		#expect(result.version == "main-ff5acfa")
		#expect(result.gitRef == "ff5acfac81370fe7aafdac0778e8f11fb8d862d3")
		#expect(result.created == "2026-03-30T08:21:16")
	}
	
	@Test func getBundleResourcesJson_withValidInput_shouldResultInAListOfResources() throws {
		
		// Given
		let json = try ResourceLoader().getResource("bundle")
		
		// When
		let result = sut.splitBundleIntoResources(json)
		
		// Then
		#expect(result.count == 2)
	}
	
	@Test func getBundleResourcesJson_withInvalidInput_shouldResultInAnEmptyList() throws {
		
		// Given
		
		// When
		let result = sut.splitBundleIntoResources(Data("wrong".utf8))
		
		// Then
		#expect(result.isEmpty)
	}
	
	@Test func parseResourceJson_withoutFHIRVersion_shouldResultInValidResource() throws {
		
		// Given
		let resource = try ResourceLoader().getStringResource("medicationResource")
		let data = Data(resource.utf8)
		
		// When
		let hcim = try #require(sut.transformFHIRResourceIntoHCIM(data))
		
		// Then
		
		let zibMedicationUse = HCIMFactory.createZibMedicationUse(hcim)
		#expect(zibMedicationUse?.medicationReference?.display == "Zestril tablet 10mg")
	}
	
	@Test func parseResourceJson_withFHIRVersion_shouldResultInValidResource() throws {
		
		// Given
		let resource = try ResourceLoader().getStringResource("medicationResource")
		let data = Data(resource.utf8)
		
		// When
		let hcim = try #require(sut.transformFHIRResourceIntoHCIM(data, fhirVersion: "R3"))
		
		// Then
		
		let zibMedicationUse = HCIMFactory.createZibMedicationUse(hcim)
		#expect(zibMedicationUse?.medicationReference?.display == "Zestril tablet 10mg")
	}
	
	@Test func parseResourceJson_withWrongFHIRVersion_shouldResultInInvalidResource() throws {
		
		// Given
		let resource = try ResourceLoader().getStringResource("medicationResource")
		let data = Data(resource.utf8)
		
		// When
		let hcim = try #require(sut.transformFHIRResourceIntoHCIM(data, fhirVersion: "R4"))
		
		// Then
		#expect(hcim == Data("null".utf8))
	}
	
	@Test func parseResourceJson_invalidData_shouldResultInInvalidResource() throws {
		
		// Given
		
		// When
		let hcim = try #require(sut.transformFHIRResourceIntoHCIM(Data("wrong".utf8)))
		
		// Then
		#expect(hcim == Data("undefined".utf8))
	}
	
	@Test func getCard_withValidInput_shouldResultInSchema() throws {
		
		// Given
		let resource = try ResourceLoader().getStringResource("zibMedicationUse")
		let data = Data(resource.utf8)
		
		// When
		let cardDetails = sut.getCard(data, organizationName: "Test Org")
		
		// Then
		#expect(cardDetails?.title == "Paracetamol tablet 500mg")
		#expect(cardDetails?.description == "Test Org")
		#expect(cardDetails?.descriptionIcon == nil)
		#expect(cardDetails?.detail == "21 juli 2020")
	}
	
	@Test func getDetails_withValidInput_shouldResultInSchema() throws {
		
		// Given
		let resource = try ResourceLoader().getStringResource("zibMedicationUse")
		let data = Data(resource.utf8)
		
		// When
		let schema = sut.getDetails(data, organizationName: "test")
		
		// Then
		#expect(schema?.label == "Medicatiegebruik")
	}
	
	@Test func getDetails_withInvalidInput_shouldNotResultInSchema() throws {
		
		// Given
		
		// When
		let schema = sut.getDetails(Data("wrong".utf8), organizationName: "test")
		
		// Then
		#expect(schema == nil)
	}
	
	@Test func getSummary_withValidInput_shouldResultInSchema() throws {
		
		// Given
		let resource = try ResourceLoader().getStringResource("zibMedicationUse")
		let data = Data(resource.utf8)
		
		// When
		let schema = sut.getSummary(data, organizationName: "test")
		
		// Then
		#expect(schema?.label == "Paracetamol tablet 500mg")
	}
	
	@Test func getSummary_withInvalidInput_shouldNotResultInSchema() throws {
		
		// Given
		
		// When
		let schema = sut.getSummary(Data("wrong".utf8), organizationName: "test")
		
		// Then
		#expect(schema == nil)
	}
}
