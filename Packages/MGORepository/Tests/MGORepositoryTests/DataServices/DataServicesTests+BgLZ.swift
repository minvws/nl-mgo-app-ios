/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import Testing
import Foundation

class DataServicesBgLZTests {
	
	var sut: DataServices!
	
	init() {
		self.sut = DataServices()
	}
	
	@Test func longTermHealthcareInformation() async throws {
		
		// Given
		
		// When
		let dataService = try #require(sut.services.first(where: { $0.id == "61" }))
		
		// Then
		#expect(dataService.id == "61")
		#expect(dataService.name == "Long-Term Healthcare Information")
		#expect(dataService.fhirVersion == "3.0")
		#expect(dataService.fhirVersionEnum == .r3)
		#expect(dataService.endpoints.count == 9)
		
		#expect(dataService.endpoints[0].id == "patient")
		#expect(dataService.endpoints[0].getPath() == "/Patient?_include=Patient:general-practitioner")
		#expect(dataService.endpoints[0].profiles.count == 1)
		#expect(dataService.endpoints[0].profiles.first == "http://fhir.nl/fhir/StructureDefinition/nl-core-patient")
		
		#expect(dataService.endpoints[1].id == "treatmentDirective")
		#expect(dataService.endpoints[1].getPath() == "/Consent?category=http://snomed.info/sct|11291000146105")
		#expect(dataService.endpoints[1].profiles.count == 1)
		#expect(dataService.endpoints[1].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-TreatmentDirective")
		
		#expect(dataService.endpoints[2].id == "advanceDirective")
		#expect(dataService.endpoints[2].getPath() == "/Consent?category=http://snomed.info/sct|11341000146107")
		#expect(dataService.endpoints[2].profiles.count == 1)
		#expect(dataService.endpoints[2].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-AdvanceDirective")
		
		#expect(dataService.endpoints[3].id == "problem")
		#expect(dataService.endpoints[3].getPath() == "/Condition")
		#expect(dataService.endpoints[3].profiles.count == 1)
		#expect(dataService.endpoints[3].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-Problem")
		
		#expect(dataService.endpoints[4].id == "allergies")
		#expect(dataService.endpoints[4].getPath() == "/AllergyIntolerance")
		#expect(dataService.endpoints[4].profiles.count == 1)
		#expect(dataService.endpoints[4].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-AllergyIntolerance")
		
		#expect(dataService.endpoints[5].id == "laboratoryTestResult")
		#expect(dataService.endpoints[5].getPath() == "/Observation/$lastn?category=http://snomed.info/sct|275711006&_include=Observation:related-target&_include=Observation:specimen")
		#expect(dataService.endpoints[5].profiles.count == 1)
		#expect(dataService.endpoints[5].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-LaboratoryTestResult-Observation")
		
		#expect(dataService.endpoints[6].id == "procedure")
		#expect(dataService.endpoints[6].getPath() == "/Procedure")
		#expect(dataService.endpoints[6].profiles.count == 1)
		#expect(dataService.endpoints[6].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-Procedure")
		
		#expect(dataService.endpoints[7].id == "careplan")
		#expect(dataService.endpoints[7].getPath() == "/CarePlan?_include=CarePlan:activity-goal:Goal&_include=CarePlan:activity-outcomereference:Observation&_include=CarePlan:activity-medicaldevice:DeviceUseStatement&_include:recurse=DeviceUseStatement:device:Device")
		#expect(dataService.endpoints[7].profiles.count == 1)
		#expect(dataService.endpoints[7].profiles.first == "http://fhir.nl/fhir/StructureDefinition/nl-core-careplan")
		
		#expect(dataService.endpoints[8].id == "careteam")
		#expect(dataService.endpoints[8].getPath() == "/CareTeam?_include=CareTeam:participant")
		#expect(dataService.endpoints[8].profiles.count == 1)
		#expect(dataService.endpoints[8].profiles.first == "http://fhir.nl/fhir/StructureDefinition/nl-core-careteam")
	}
}
