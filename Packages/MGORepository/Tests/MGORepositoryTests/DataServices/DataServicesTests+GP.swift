/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import Testing
import Foundation

class DataServicesGPTests {
	
	var sut: DataServices!
	
	init() {
		self.sut = DataServices()
	}
	
	@Test func generalPractitioner_isDemo() async throws {
		
		// Given
		sut = DataServices(isDemo: true)
		
		// When
		let dataService = try #require(sut.services.first(where: { $0.id == "49" }))
		
		// Then
		#expect(dataService.id == "49")
		#expect(dataService.name == "General Practitioner Data (demo)")
		#expect(dataService.fhirVersion == "3.0")
		#expect(dataService.fhirVersionEnum == .r3)
		#expect(dataService.endpoints.count == 1)
		
		#expect(dataService.endpoints[0].id == "diagnosticAndLabResults")
		#expect(dataService.endpoints[0].getPath() == "/Observation?code=https://referentiemodel.nhg.org/tabellen/nhg-tabel-45-diagnostische-bepalingen|&_include=Observation:related-target&_include=Observation:specimen")
		#expect(dataService.endpoints[0].profiles.count == 2)
		#expect(dataService.endpoints[0].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/gp-DiagnosticResult")
		#expect(dataService.endpoints[0].profiles.last == "http://nictiz.nl/fhir/StructureDefinition/gp-LaboratoryResult")
	}
	
	@Test func generalPractitioner() async throws {
		
		// Given
		let date = Date(timeIntervalSince1970: 1740000000)
		
		// When
		let dataService = try #require(sut.services.first(where: { $0.id == "49" }))
		
		// Then
		#expect(dataService.id == "49")
		#expect(dataService.name == "General Practitioner Data")
		#expect(dataService.fhirVersion == "3.0")
		#expect(dataService.fhirVersionEnum == .r3)
		#expect(dataService.endpoints.count == 7)
		
		#expect(dataService.endpoints[0].id == "patient")
		#expect(dataService.endpoints[0].getPath() == "/Patient?_include=Patient:general-practitioner")
		#expect(dataService.endpoints[0].profiles.count == 1)
		#expect(dataService.endpoints[0].profiles.first == "http://fhir.nl/fhir/StructureDefinition/nl-core-patient")
		
		#expect(dataService.endpoints[1].id == "episodes")
		#expect(dataService.endpoints[1].getPath() == "/EpisodeOfCare")
		#expect(dataService.endpoints[1].profiles.count == 2)
		#expect(dataService.endpoints[1].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-Alert")
		#expect(dataService.endpoints[1].profiles.last == "http://fhir.nl/fhir/StructureDefinition/nl-core-episodeofcare")
		
		#expect(dataService.endpoints[2].id == "currentMedication")
		#expect(dataService.endpoints[2].getPath(date) == "/MedicationRequest?periodofuse=ge2025-02-19&category=http://snomed.info/sct|16076005&_include=MedicationRequest:medication")
		#expect(dataService.endpoints[2].profiles.count == 1)
		#expect(dataService.endpoints[2].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-MedicationAgreement")
		
		#expect(dataService.endpoints[3].id == "allergies")
		#expect(dataService.endpoints[3].getPath() == "/AllergyIntolerance?category=medication")
		#expect(dataService.endpoints[3].profiles.count == 1)
		#expect(dataService.endpoints[3].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-AllergyIntolerance")
		
		#expect(dataService.endpoints[4].id == "diagnosticAndLabResults")
		#expect(dataService.endpoints[4].getPath() == "/Observation?code=https://referentiemodel.nhg.org/tabellen/nhg-tabel-45-diagnostische-bepalingen|&_include=Observation:related-target&_include=Observation:specimen")
		#expect(dataService.endpoints[4].profiles.count == 2)
		#expect(dataService.endpoints[4].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/gp-DiagnosticResult")
		#expect(dataService.endpoints[4].profiles.last == "http://nictiz.nl/fhir/StructureDefinition/gp-LaboratoryResult")
		
		#expect(dataService.endpoints[5].id == "soapEntries")
		#expect(dataService.endpoints[5].getPath() == "/Composition?type=http://loinc.org|67781-5")
		#expect(dataService.endpoints[5].profiles.count == 2)
		#expect(dataService.endpoints[5].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/gp-EncounterReport")
		#expect(dataService.endpoints[5].profiles.last == "http://nictiz.nl/fhir/StructureDefinition/gp-JournalEntry")
		
		#expect(dataService.endpoints[6].id == "encounters")
		#expect(dataService.endpoints[6].getPath() == "/Encounter")
		#expect(dataService.endpoints[6].profiles.count == 1)
		#expect(dataService.endpoints[6].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/gp-Encounter")
	}
	
	@Test func generalPractitioner_withTimeZoneTest() async throws {
		
		// Given
		let date = Date(timeIntervalSince1970: 1740009599)
		/*
		 GMT: Wednesday, 19 February 2025 23:59:59
		 Your time zone: Thursday, 20 February 2025 00:59:59 GMT+01:00
		 */
		
		// When
		let dataService = try #require(sut.services.first(where: { $0.id == "49" }))
		
		// Then
		#expect(dataService.endpoints[2].getPath(date) == "/MedicationRequest?periodofuse=ge2025-02-20&category=http://snomed.info/sct|16076005&_include=MedicationRequest:medication")
	}
}
