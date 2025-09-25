/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import Testing
import Foundation

class DataServicesTests {
	
	var sut: DataServices!
	
	init() {
		self.sut = DataServices()
	}
	
	@Test func initializer() async throws {
		
		// Given
		
		// When
		
		// Then
		#expect(sut.services.count == 4)
	}
	
	// swiftlint: disable function_body_length
	@Test func commonClinicalDataset() async throws {
		
		// Given
		
		// When
		let dataService = try #require(sut.services.first(where: { $0.id == "48" }))
		
		// Then
		#expect(dataService.id == "48")
		#expect(dataService.name == "Common Clinical Dataset")
		#expect(dataService.fhirVersion == .r3)
		#expect(dataService.endpoints.count == 28)
		
		#expect(dataService.endpoints[0].id == "patient")
		#expect(dataService.endpoints[0].getUrl() == "/Patient?_include=Patient:general-practitioner")
		#expect(dataService.endpoints[0].profiles.count == 1)
		#expect(dataService.endpoints[0].profiles.first == "http://fhir.nl/fhir/StructureDefinition/nl-core-patient")
		
		#expect(dataService.endpoints[1].id == "payer")
		#expect(dataService.endpoints[1].getUrl() == "/Coverage?_include=Coverage:payor:Patient&_include=Coverage:payor:Organization")
		#expect(dataService.endpoints[1].profiles.count == 3)
		#expect(dataService.endpoints[1].profiles[0] == "http://nictiz.nl/fhir/StructureDefinition/zib-Payer")
		#expect(dataService.endpoints[1].profiles[1] == "http://fhir.nl/fhir/StructureDefinition/nl-core-organization")
		#expect(dataService.endpoints[1].profiles[2] == "http://fhir.nl/fhir/StructureDefinition/nl-core-patient")
		
		#expect(dataService.endpoints[2].id == "treatmentDirective")
		#expect(dataService.endpoints[2].getUrl() == "/Consent?category=http://snomed.info/sct|11291000146105")
		#expect(dataService.endpoints[2].profiles.count == 1)
		#expect(dataService.endpoints[2].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-TreatmentDirective")
		
		#expect(dataService.endpoints[3].id == "advanceDirective")
		#expect(dataService.endpoints[3].getUrl() == "/Consent?category=http://snomed.info/sct|11341000146107")
		#expect(dataService.endpoints[3].profiles.count == 1)
		#expect(dataService.endpoints[3].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-AdvanceDirective")
		
		#expect(dataService.endpoints[4].id == "functionalOrMentalStatus")
		#expect(dataService.endpoints[4].getUrl() == "/Observation/$lastn?category=http://snomed.info/sct|118228005,http://snomed.info/sct|384821006")
		#expect(dataService.endpoints[4].profiles.count == 1)
		#expect(dataService.endpoints[4].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-FunctionalOrMentalStatus")
		
		#expect(dataService.endpoints[5].id == "problem")
		#expect(dataService.endpoints[5].getUrl() == "/Condition")
		#expect(dataService.endpoints[5].profiles.count == 1)
		#expect(dataService.endpoints[5].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-Problem")
		
		#expect(dataService.endpoints[6].id == "livingSituation")
		#expect(dataService.endpoints[6].getUrl() == "/Observation/$lastn?code=http://snomed.info/sct|365508006")
		#expect(dataService.endpoints[6].profiles.count == 1)
		#expect(dataService.endpoints[6].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-LivingSituation")
		
		#expect(dataService.endpoints[7].id == "drugUse")
		#expect(dataService.endpoints[7].getUrl() == "/Observation?code=http://snomed.info/sct|228366006")
		#expect(dataService.endpoints[7].profiles.count == 1)
		#expect(dataService.endpoints[7].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-DrugUse")
		
		#expect(dataService.endpoints[8].id == "alcoholUse")
		#expect(dataService.endpoints[8].getUrl() == "/Observation?code=http://snomed.info/sct|228273003")
		#expect(dataService.endpoints[8].profiles.count == 1)
		#expect(dataService.endpoints[8].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-AlcoholUse")
		
		#expect(dataService.endpoints[9].id == "tobaccoUse")
		#expect(dataService.endpoints[9].getUrl() == "/Observation?code=http://snomed.info/sct|365980008")
		#expect(dataService.endpoints[9].profiles.count == 1)
		#expect(dataService.endpoints[9].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-TobaccoUse")
		
		#expect(dataService.endpoints[10].id == "nutritionAdvice")
		#expect(dataService.endpoints[10].getUrl() == "/NutritionOrder")
		#expect(dataService.endpoints[10].profiles.count == 1)
		#expect(dataService.endpoints[10].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-NutritionAdvice")
		
		#expect(dataService.endpoints[11].id == "alert")
		#expect(dataService.endpoints[11].getUrl() == "/Flag")
		#expect(dataService.endpoints[11].profiles.count == 1)
		#expect(dataService.endpoints[11].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-Alert")
		
		#expect(dataService.endpoints[12].id == "allergies")
		#expect(dataService.endpoints[12].getUrl() == "/AllergyIntolerance")
		#expect(dataService.endpoints[12].profiles.count == 1)
		#expect(dataService.endpoints[12].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-AllergyIntolerance")
		
		#expect(dataService.endpoints[13].id == "medicationUse")
		#expect(dataService.endpoints[13].getUrl() == "/MedicationStatement?category=urn:oid:2.16.840.1.113883.2.4.3.11.60.20.77.5.3|6&_include=MedicationStatement:medication")
		#expect(dataService.endpoints[13].profiles.count == 1)
		#expect(dataService.endpoints[13].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-MedicationUse")
		
		#expect(dataService.endpoints[14].id == "medicationAgreements")
		#expect(dataService.endpoints[14].getUrl() == "/MedicationRequest?category=http://snomed.info/sct|16076005&_include=MedicationRequest:medication")
		#expect(dataService.endpoints[14].profiles.count == 1)
		#expect(dataService.endpoints[14].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-MedicationAgreement")
		
		#expect(dataService.endpoints[15].id == "administrationAgreement")
		#expect(dataService.endpoints[15].getUrl() == "/MedicationDispense?category=http://snomed.info/sct|422037009&_include=MedicationDispense:medication")
		#expect(dataService.endpoints[15].profiles.count == 1)
		#expect(dataService.endpoints[15].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-AdministrationAgreement")
		
		#expect(dataService.endpoints[16].id == "medicalDevice")
		#expect(dataService.endpoints[16].getUrl() == "/DeviceUseStatement?_include=DeviceUseStatement:device")
		#expect(dataService.endpoints[16].profiles.count == 2)
		#expect(dataService.endpoints[16].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-MedicalDevice")
		#expect(dataService.endpoints[16].profiles.last == "http://nictiz.nl/fhir/StructureDefinition/zib-MedicalDeviceProduct")
		
		#expect(dataService.endpoints[17].id == "vaccination")
		#expect(dataService.endpoints[17].getUrl() == "/Immunization?status=completed")
		#expect(dataService.endpoints[17].profiles.count == 1)
		#expect(dataService.endpoints[17].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-Vaccination")
		
		#expect(dataService.endpoints[18].id == "bloodPressure")
		#expect(dataService.endpoints[18].getUrl() == "/Observation/$lastn?code=http://loinc.org|85354-9")
		#expect(dataService.endpoints[18].profiles.count == 1)
		#expect(dataService.endpoints[18].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-BloodPressure")
		
		#expect(dataService.endpoints[19].id == "bodyWeight")
		#expect(dataService.endpoints[19].getUrl() == "/Observation/$lastn?code=http://loinc.org|29463-7")
		#expect(dataService.endpoints[19].profiles.count == 1)
		#expect(dataService.endpoints[19].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-BodyWeight")
		
		#expect(dataService.endpoints[20].id == "bodyHeight")
		#expect(dataService.endpoints[20].getUrl() == "/Observation/$lastn?code=http://loinc.org|8302-2,http://loinc.org|8306-3,http://loinc.org|8308-9")
		#expect(dataService.endpoints[20].profiles.count == 1)
		#expect(dataService.endpoints[20].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-BodyHeight")
		
		#expect(dataService.endpoints[21].id == "laboratoryTestResult")
		#expect(dataService.endpoints[21].getUrl() == "/Observation/$lastn?category=http://snomed.info/sct|275711006&_include=Observation:related-target&_include=Observation:specimen")
		#expect(dataService.endpoints[21].profiles.count == 2)
		#expect(dataService.endpoints[21].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-LaboratoryTestResult-Observation")
		#expect(dataService.endpoints[21].profiles.last == "http://nictiz.nl/fhir/StructureDefinition/zib-LaboratoryTestResult-Specimen")
		
		#expect(dataService.endpoints[22].id == "procedure")
		#expect(dataService.endpoints[22].getUrl() == "/Procedure?category=http://snomed.info/sct|387713003")
		#expect(dataService.endpoints[22].profiles.count == 1)
		#expect(dataService.endpoints[22].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-Procedure")
		
		#expect(dataService.endpoints[23].id == "encounter")
		#expect(dataService.endpoints[23].getUrl() == "/Encounter?class=http://hl7.org/fhir/v3/ActCode|IMP,http://hl7.org/fhir/v3/ActCode|ACUTE,http://hl7.org/fhir/v3/ActCode|NONAC")
		#expect(dataService.endpoints[23].profiles.count == 1)
		#expect(dataService.endpoints[23].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-Encounter")
		
		#expect(dataService.endpoints[24].id == "plannedProcedures")
		#expect(dataService.endpoints[24].getUrl() == "/ProcedureRequest?status=active")
		#expect(dataService.endpoints[24].profiles.count == 1)
		#expect(dataService.endpoints[24].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-ProcedureRequest")
		
		#expect(dataService.endpoints[25].id == "plannedImmunization")
		#expect(dataService.endpoints[25].getUrl() == "/ImmunizationRecommendation")
		#expect(dataService.endpoints[25].profiles.count == 1)
		#expect(dataService.endpoints[25].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-VaccinationRecommendation")
		
		#expect(dataService.endpoints[26].id == "plannedMedicalDevices")
		#expect(dataService.endpoints[26].getUrl() == "/DeviceRequest?status=active&_include=DeviceRequest:device")
		#expect(dataService.endpoints[26].profiles.count == 1)
		#expect(dataService.endpoints[26].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-MedicalDeviceRequest")
		
		#expect(dataService.endpoints[27].id == "plannedEncounters")
		#expect(dataService.endpoints[27].getUrl() == "/Appointment?status=booked,pending,proposed")
		#expect(dataService.endpoints[27].profiles.count == 1)
		#expect(dataService.endpoints[27].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/eAfspraak-Appointment")
	}
	// swiftlint: enable function_body_length
	
	@Test func commonClinicalDataset_isDemo() async throws {
		
		// Given
		sut = DataServices(isDemo: true)
		
		// When
		let dataService = try #require(sut.services.first(where: { $0.id == "48" }))
		
		// Then
		#expect(dataService.id == "48")
		#expect(dataService.name == "Common Clinical Dataset (demo)")
		#expect(dataService.fhirVersion == .r3)
		#expect(dataService.endpoints.count == 3)
		
		#expect(dataService.endpoints[0].id == "medicationUse")
		#expect(dataService.endpoints[0].getUrl() == "/MedicationStatement?category=urn:oid:2.16.840.1.113883.2.4.3.11.60.20.77.5.3|6&_include=MedicationStatement:medication")
		#expect(dataService.endpoints[0].profiles.count == 1)
		#expect(dataService.endpoints[0].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-MedicationUse")
		
		#expect(dataService.endpoints[1].id == "laboratoryTestResult")
		#expect(dataService.endpoints[1].getUrl() == "/Observation/$lastn?category=http://snomed.info/sct|275711006&_include=Observation:related-target&_include=Observation:specimen")
		#expect(dataService.endpoints[1].profiles.count == 1)
		#expect(dataService.endpoints[1].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-LaboratoryTestResult-Observation")
		
		#expect(dataService.endpoints[2].id == "problem")
		#expect(dataService.endpoints[2].getUrl() == "/Condition")
		#expect(dataService.endpoints[2].profiles.count == 1)
		#expect(dataService.endpoints[2].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-Problem")
	}
	
	@Test func generalPractitioner_isDemo() async throws {
		
		// Given
		sut = DataServices(isDemo: true)
		
		// When
		let dataService = try #require(sut.services.first(where: { $0.id == "49" }))
		
		// Then
		#expect(dataService.id == "49")
		#expect(dataService.name == "General Practitioner Data (demo)")
		#expect(dataService.fhirVersion == .r3)
		#expect(dataService.endpoints.count == 1)
		
		#expect(dataService.endpoints[0].id == "diagnosticAndLabResults")
		#expect(dataService.endpoints[0].getUrl() == "/Observation?code=https://referentiemodel.nhg.org/tabellen/nhg-tabel-45-diagnostische-bepalingen|&_include=Observation:related-target&_include=Observation:specimen")
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
		#expect(dataService.fhirVersion == .r3)
		#expect(dataService.endpoints.count == 7)
		
		#expect(dataService.endpoints[0].id == "patient")
		#expect(dataService.endpoints[0].getUrl() == "/Patient?_include=Patient:general-practitioner")
		#expect(dataService.endpoints[0].profiles.count == 1)
		#expect(dataService.endpoints[0].profiles.first == "http://fhir.nl/fhir/StructureDefinition/nl-core-patient")
		
		#expect(dataService.endpoints[1].id == "episodes")
		#expect(dataService.endpoints[1].getUrl() == "/EpisodeOfCare")
		#expect(dataService.endpoints[1].profiles.count == 2)
		#expect(dataService.endpoints[1].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-Alert")
		#expect(dataService.endpoints[1].profiles.last == "http://fhir.nl/fhir/StructureDefinition/nl-core-episodeofcare")
		
		#expect(dataService.endpoints[2].id == "currentMedication")
		#expect(dataService.endpoints[2].getUrl(date) == "/MedicationRequest?periodofuse=ge2025-02-19&category=http://snomed.info/sct|16076005&_include=MedicationRequest:medication")
		#expect(dataService.endpoints[2].profiles.count == 1)
		#expect(dataService.endpoints[2].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-MedicationAgreement")
		
		#expect(dataService.endpoints[3].id == "allergies")
		#expect(dataService.endpoints[3].getUrl() == "/AllergyIntolerance?category=medication")
		#expect(dataService.endpoints[3].profiles.count == 1)
		#expect(dataService.endpoints[3].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/zib-AllergyIntolerance")
		
		#expect(dataService.endpoints[4].id == "diagnosticAndLabResults")
		#expect(dataService.endpoints[4].getUrl() == "/Observation?code=https://referentiemodel.nhg.org/tabellen/nhg-tabel-45-diagnostische-bepalingen|&_include=Observation:related-target&_include=Observation:specimen")
		#expect(dataService.endpoints[4].profiles.count == 2)
		#expect(dataService.endpoints[4].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/gp-DiagnosticResult")
		#expect(dataService.endpoints[4].profiles.last == "http://nictiz.nl/fhir/StructureDefinition/gp-LaboratoryResult")
		
		#expect(dataService.endpoints[5].id == "soapEntries")
		#expect(dataService.endpoints[5].getUrl() == "/Composition?type=http://loinc.org|67781-5")
		#expect(dataService.endpoints[5].profiles.count == 2)
		#expect(dataService.endpoints[5].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/gp-EncounterReport")
		#expect(dataService.endpoints[5].profiles.last == "http://nictiz.nl/fhir/StructureDefinition/gp-JournalEntry")
		
		#expect(dataService.endpoints[6].id == "encounters")
		#expect(dataService.endpoints[6].getUrl() == "/Encounter")
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
		#expect(dataService.endpoints[2].getUrl(date) == "/MedicationRequest?periodofuse=ge2025-02-20&category=http://snomed.info/sct|16076005&_include=MedicationRequest:medication")
	}
	
	@Test func documents() async throws {
		
		// Given
		
		// When
		let dataService = try #require(sut.services.first(where: { $0.id == "51" }))
		
		// Then
		#expect(dataService.id == "51")
		#expect(dataService.name == "Documents PDF/A")
		#expect(dataService.fhirVersion == .r3)
		#expect(dataService.endpoints.count == 1)
		
		#expect(dataService.endpoints[0].id == "documentReference")
		#expect(dataService.endpoints[0].getUrl() == "/DocumentReference")
		#expect(dataService.endpoints[0].profiles.count == 1)
		#expect(dataService.endpoints[0].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/IHE.MHD.Minimal.DocumentReference")
	}
	
	@Test func vaccinations() async throws {
		
		// Given
		
		// When
		let dataService = try #require(sut.services.first(where: { $0.id == "63" }))
		
		// Then
		#expect(dataService.id == "63")
		#expect(dataService.name == "Vaccination Immunization")
		#expect(dataService.fhirVersion == .r4)
		#expect(dataService.endpoints.count == 1)
		
		#expect(dataService.endpoints[0].id == "vaccination")
		#expect(dataService.endpoints[0].getUrl() == "/Immunization")
		#expect(dataService.endpoints[0].profiles.count == 1)
		#expect(dataService.endpoints[0].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/nl-core-Vaccination-event")
	}
}
