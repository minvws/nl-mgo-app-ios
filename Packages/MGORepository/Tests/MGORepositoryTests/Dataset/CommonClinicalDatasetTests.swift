/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import MGOTest
import FHIRClient

final class CommonClinicalDatasetTests: XCTestCase {
	
	func test_endpoint_patient() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.patient
		
		// Then
		expect(endpoint.path) == "Patient"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "_include", value: "Patient:general-practitioner") } == true
	}
	
	func test_endpoint_payer() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.payer
		
		// Then
		expect(endpoint.path) == "Coverage"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "_include", value: "Coverage:payor:Patient") } == true
		expect { try self.contains(endpoint, key: "_include", value: "Coverage:payor:Organization") } == true
	}
	
	func test_endpoint_treatmentDirective() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.treatmentDirective
		
		// Then
		expect(endpoint.path) == "Consent"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "category", value: "http://snomed.info/sct|11291000146105") } == true
	}
	
	func test_endpoint_advanceDirective() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.advanceDirective
		
		// Then
		expect(endpoint.path) == "Consent"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "category", value: "http://snomed.info/sct|11341000146107") } == true
	}
	
	func test_endpoint_functionalOrMentalStatus() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.functionalOrMentalStatus
		
		// Then
		expect(endpoint.path) == "Observation"
		expect(endpoint.directory) == "$lastn"
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "category", value: "http://snomed.info/sct|118228005,http://snomed.info/sct|384821006") } == true
	}
	
	func test_endpoint_problem() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.problem
		
		// Then
		expect(endpoint.path) == "Condition"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect(endpoint.parameters) == nil
	}
	
	func test_endpoint_livingSituation() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.livingSituation
		
		// Then
		expect(endpoint.path) == "Observation"
		expect(endpoint.directory) == "$lastn"
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "code", value: "http://snomed.info/sct|365508006") } == true
	}
	
	func test_endpoint_drugUse() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.drugUse
		
		// Then
		expect(endpoint.path) == "Observation"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "code", value: "http://snomed.info/sct|228366006") } == true
	}
	
	func test_endpoint_alcoholUse() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.alcoholUse
		
		// Then
		expect(endpoint.path) == "Observation"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "code", value: "http://snomed.info/sct|228273003") } == true
	}
	
	func test_endpoint_tobaccoUse() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.tobaccoUse
		
		// Then
		expect(endpoint.path) == "Observation"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "code", value: "http://snomed.info/sct|365980008") } == true
	}
	
	func test_endpoint_nutritionAdvice() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.nutritionAdvice
		
		// Then
		expect(endpoint.path) == "NutritionOrder"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect(endpoint.parameters) == nil
	}
	
	func test_endpoint_alert() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.alert
		
		// Then
		expect(endpoint.path) == "Flag"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect(endpoint.parameters) == nil
	}
	
	func test_endpoint_allergyIntolerance() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.allergyIntolerance
		
		// Then
		expect(endpoint.path) == "AllergyIntolerance"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect(endpoint.parameters) == nil
	}
	
	func test_endpoint_medicationUse() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.medicationUse
		
		// Then
		expect(endpoint.path) == "MedicationStatement"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "category", value: "urn:oid:2.16.840.1.113883.2.4.3.11.60.20.77.5.3|6") } == true
		expect { try self.contains(endpoint, key: "_include", value: "MedicationStatement:medication") } == true
	}
	
	func test_endpoint_medicationAgreement() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.medicationAgreement
		
		// Then
		expect(endpoint.path) == "MedicationRequest"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "category", value: "http://snomed.info/sct|16076005") } == true
		expect { try self.contains(endpoint, key: "_include", value: "MedicationRequest:medication") } == true
	}
	
	func test_endpoint_administrationAgreement() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.administrationAgreement
		
		// Then
		expect(endpoint.path) == "MedicationDispense"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "category", value: "http://snomed.info/sct|422037009") } == true
		expect { try self.contains(endpoint, key: "_include", value: "MedicationDispense:medication") } == true
	}
	
	func test_endpoint_medicalDevice() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.medicalDevice
		
		// Then
		expect(endpoint.path) == "DeviceUseStatement"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "_include", value: "DeviceUseStatement:device") } == true
	}
	
	func test_endpoint_vaccination() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.vaccination
		
		// Then
		expect(endpoint.path) == "Immunization"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "status", value: "completed") } == true
	}
	
	func test_endpoint_bloodPressure() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.bloodPressure
		
		// Then
		expect(endpoint.path) == "Observation"
		expect(endpoint.directory) == "$lastn"
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "code", value: "http://loinc.org|85354-9") } == true
	}
	
	func test_endpoint_bodyWeight() throws {
		
		// Given
		
		let endpoint = DVP.CommonClinicalDataset.bodyWeight
		// When
		
		// Then
		expect(endpoint.path) == "Observation"
		expect(endpoint.directory) == "$lastn"
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "code", value: "http://loinc.org|29463-7") } == true
	}
	
	func test_endpoint_bodyHeight() throws {
		
		// Given
		
		let endpoint = DVP.CommonClinicalDataset.bodyHeight
		// When
		
		// Then
		expect(endpoint.path) == "Observation"
		expect(endpoint.directory) == "$lastn"
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "code", value: "http://loinc.org|8302-2,http://loinc.org|8306-3,http://loinc.org|8308-9") } == true
	}
	
	func test_endpoint_laboratoryTestResult() throws {
		
		// Given
		
		let endpoint = DVP.CommonClinicalDataset.laboratoryTestResult
		// When
		
		// Then
		expect(endpoint.path) == "Observation"
		expect(endpoint.directory) == "$lastn"
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "category", value: "http://snomed.info/sct|275711006") } == true
		expect { try self.contains(endpoint, key: "_include", value: "Observation:related-target") } == true
		expect { try self.contains(endpoint, key: "_include", value: "Observation:specimen") } == true
	}
	
	func test_endpoint_procedure() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.procedure
		
		// Then
		expect(endpoint.path) == "Procedure"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "category", value: "http://snomed.info/sct|387713003") } == true
	}
	
	func test_endpoint_encounter() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.encounter
		
		// Then
		expect(endpoint.path) == "Encounter"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "class", value: "http://hl7.org/fhir/v3/ActCode|IMP,http://hl7.org/fhir/v3/ActCode|ACUTE,http://hl7.org/fhir/v3/ActCode|NONAC") } == true
	}
	
	func test_endpoint_plannedProcedures() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.plannedProcedures
		
		// Then
		expect(endpoint.path) == "ProcedureRequest"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "status", value: "active") } == true
	}
	
	func test_endpoint_plannedImmunization() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.plannedImmunization
		
		// Then
		expect(endpoint.path) == "ImmunizationRecommendation"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect(endpoint.parameters) == nil
	}
	
	func test_endpoint_plannedMedicalDevices() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.plannedMedicalDevices
		
		// Then
		expect(endpoint.path) == "DeviceRequest"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "status", value: "active") } == true
		expect { try self.contains(endpoint, key: "_include", value: "DeviceRequest:device") } == true
	}
	
	func test_endpoint_plannedEncounters() throws {
		
		// Given
		
		// When
		let endpoint = DVP.CommonClinicalDataset.plannedEncounters
		
		// Then
		expect(endpoint.path) == "Appointment"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "status", value: "booked,pending,proposed") } == true
	}
}
