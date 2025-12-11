/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import Testing
import Foundation

class DataServicesBgGGZTests {
	
	var sut: DataServices!
	
	init() {
		self.sut = DataServices()
	}
	
	@Test func mentalHealthCareInformation() async throws {
		
		// Given
		
		// When
		let dataService = try #require(sut.services.first(where: { $0.id == "50" }))
		
		// Then
		#expect(dataService.id == "50")
		#expect(dataService.name == "Mental Health Care Information")
		#expect(dataService.fhirVersion == "3.0")
		#expect(dataService.fhirVersionEnum == .r3)
		#expect(dataService.endpoints.count == 18)
		
		#expect(dataService.endpoints[0].id == "patient")
		#expect(dataService.endpoints[0].getPath() == "/Patient?_include=Patient:general-practitioner")
		#expect(dataService.endpoints[0].profiles.count == 1)
		#expect(dataService.endpoints[0].profiles.first == "http://fhir.nl/fhir/StructureDefinition/nl-core-patient")
		
		#expect(dataService.endpoints[1].id == "payer")
		#expect(dataService.endpoints[1].getPath() == "/Coverage?_include=Coverage:payor:Patient&_include=Coverage:payor:Organization")
		#expect(dataService.endpoints[1].profiles.count == 1)
		#expect(dataService.endpoints[1].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-Payer")
		
		#expect(dataService.endpoints[2].id == "treatmentDirective")
		#expect(dataService.endpoints[2].getPath() == "/Consent?category=http://snomed.info/sct|11291000146105")
		#expect(dataService.endpoints[2].profiles.count == 1)
		#expect(dataService.endpoints[2].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-TreatmentDirective")
		
		#expect(dataService.endpoints[3].id == "advanceDirective")
		#expect(dataService.endpoints[3].getPath() == "/Consent?category=http://snomed.info/sct|11341000146107")
		#expect(dataService.endpoints[3].profiles.count == 1)
		#expect(dataService.endpoints[3].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-AdvanceDirective")
		
		#expect(dataService.endpoints[4].id == "functionalOrMentalStatus")
		#expect(dataService.endpoints[4].getPath() == "/Observation?category=http://snomed.info/sct|118228005,http://snomed.info/sct|384821006")
		#expect(dataService.endpoints[4].profiles.count == 1)
		#expect(dataService.endpoints[4].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-FunctionalOrMentalStatus")
		
		#expect(dataService.endpoints[5].id == "problem")
		#expect(dataService.endpoints[5].getPath() == "/Condition")
		#expect(dataService.endpoints[5].profiles.count == 1)
		#expect(dataService.endpoints[5].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-Problem")
		
		#expect(dataService.endpoints[6].id == "drugUse")
		#expect(dataService.endpoints[6].getPath() == "/Observation?code=http://snomed.info/sct|228366006")
		#expect(dataService.endpoints[6].profiles.count == 1)
		#expect(dataService.endpoints[6].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-DrugUse")
		
		#expect(dataService.endpoints[7].id == "alcoholUse")
		#expect(dataService.endpoints[7].getPath() == "/Observation?code=http://snomed.info/sct|228273003")
		#expect(dataService.endpoints[7].profiles.count == 1)
		#expect(dataService.endpoints[7].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-AlcoholUse")
		
		#expect(dataService.endpoints[8].id == "tobaccoUse")
		#expect(dataService.endpoints[8].getPath() == "/Observation?code=http://snomed.info/sct|365980008")
		#expect(dataService.endpoints[8].profiles.count == 1)
		#expect(dataService.endpoints[8].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-TobaccoUse")
		
		#expect(dataService.endpoints[9].id == "livingSituation")
		#expect(dataService.endpoints[9].getPath() == "/Observation/$lastn?code=http://snomed.info/sct|365508006")
		#expect(dataService.endpoints[9].profiles.count == 1)
		#expect(dataService.endpoints[9].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-LivingSituation")
		
		#expect(dataService.endpoints[10].id == "familySituation")
		#expect(dataService.endpoints[10].getPath() == "/Observation?code=http://snomed.info/sct|365470003")
		#expect(dataService.endpoints[10].profiles.count == 1)
		#expect(dataService.endpoints[10].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-FamilySituation")
		
		#expect(dataService.endpoints[11].id == "participationInSociety")
		#expect(dataService.endpoints[11].getPath() == "/Observation?code=http://snomed.info/sct|314845004")
		#expect(dataService.endpoints[11].profiles.count == 1)
		#expect(dataService.endpoints[11].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-ParticipationInSociety")
		
		#expect(dataService.endpoints[12].id == "helpFromOthers")
		#expect(dataService.endpoints[12].getPath() == "/CarePlan?category=http://snomed.info/sct|243114000")
		#expect(dataService.endpoints[12].profiles.count == 1)
		#expect(dataService.endpoints[12].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-HelpFromOthers")
		
		#expect(dataService.endpoints[13].id == "laboratoryTestResult")
		#expect(dataService.endpoints[13].getPath() == "/Observation/$lastn?category=http://snomed.info/sct|275711006&_include=Observation:related-target&_include=Observation:specimen")
		#expect(dataService.endpoints[13].profiles.count == 1)
		#expect(dataService.endpoints[13].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-LaboratoryTestResult-Observation")
		
		#expect(dataService.endpoints[14].id == "generalMeasurement")
		#expect(dataService.endpoints[14].getPath() == "/Observation?category=http://hl7.org/fhir/observation-category|survey")
		#expect(dataService.endpoints[14].profiles.count == 1)
		#expect(dataService.endpoints[14].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-GeneralMeasurement")
		
		#expect(dataService.endpoints[15].id == "procedure")
		#expect(dataService.endpoints[15].getPath() == "/Procedure")
		#expect(dataService.endpoints[15].profiles.count == 1)
		#expect(dataService.endpoints[15].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-Procedure")
		
		#expect(dataService.endpoints[16].id == "textResult")
		#expect(dataService.endpoints[16].getPath() == "/DiagnosticReport")
		#expect(dataService.endpoints[16].profiles.count == 1)
		#expect(dataService.endpoints[16].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-TextReport")
		
		#expect(dataService.endpoints[17].id == "careteam")
		#expect(dataService.endpoints[17].getPath() == "/CareTeam?_include=CareTeam:participant")
		#expect(dataService.endpoints[17].profiles.count == 1)
		#expect(dataService.endpoints[17].profiles.first == "http://fhir.nl/fhir/StructureDefinition/nl-core-careteam")
	}
}
