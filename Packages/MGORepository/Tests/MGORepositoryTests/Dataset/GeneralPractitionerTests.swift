/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import MGOTest
import FHIRClient

final class GeneralPractitionerTests: XCTestCase {
	
	func test_endpoint_patient() throws {
		
		// Given
		
		// When
		let endpoint = DVP.GeneralPractitioner.patient
		
		// Then
		expect(endpoint.path) == "Patient"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect(endpoint.parameters) != nil
		expect { try self.contains(endpoint, key: "_include", value: "Patient:general-practitioner") } == true
	}
	
	func test_endpoint_episodes() throws {
		
		// Given
		
		// When
		let endpoint = DVP.GeneralPractitioner.episodes
		
		// Then
		expect(endpoint.path) == "EpisodeOfCare"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect(endpoint.parameters) == nil
	}
	
	func test_endpoint_currentMedication() throws {
		
		// Given
		let date = Date(timeIntervalSince1970: 1740000000)
		
		// When
		let endpoint = DVP.GeneralPractitioner.currentMedication(date)
		
		// Then
		expect(endpoint.path) == "MedicationRequest"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect(endpoint.parameters) != nil
		expect { try self.contains(endpoint, key: "periodofuse", value: "ge2025-02-19") } == true
		expect { try self.contains(endpoint, key: "category", value: "http://snomed.info/sct|16076005") } == true
		expect { try self.contains(endpoint, key: "_include", value: "MedicationRequest:medication") } == true
	}
	
	func test_endpoint_currentMedication_timezone() throws {
		
		// Given
		let date = Date(timeIntervalSince1970: 1740009599)
		/*
		 GMT: Wednesday, 19 February 2025 23:59:59
		 Your time zone: Thursday, 20 February 2025 00:59:59 GMT+01:00
		 */
		
		// When
		let endpoint = DVP.GeneralPractitioner.currentMedication(date)
		
		// Then
		expect(endpoint.path) == "MedicationRequest"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect(endpoint.parameters) != nil
		expect { try self.contains(endpoint, key: "periodofuse", value: "ge2025-02-20") } == true
		expect { try self.contains(endpoint, key: "category", value: "http://snomed.info/sct|16076005") } == true
		expect { try self.contains(endpoint, key: "_include", value: "MedicationRequest:medication") } == true
	}
	
	func test_endpoint_allergyIntolerance() throws {
		
		// Given
		
		// When
		let endpoint = DVP.GeneralPractitioner.allergyIntolerance
		
		// Then
		expect(endpoint.path) == "AllergyIntolerance"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect(endpoint.parameters) != nil
		expect { try self.contains(endpoint, key: "category", value: "medication") } == true
	}
	
	func test_endpoint_diagnosticAndLabResults() throws {
		
		// Given
		
		// When
		let endpoint = DVP.GeneralPractitioner.diagnosticAndLabResults
		
		// Then
		expect(endpoint.path) == "Observation"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect(endpoint.parameters) != nil
		expect { try self.contains(endpoint, key: "code", value: "https://referentiemodel.nhg.org/tabellen/nhg-tabel-45-diagnostische-bepalingen|") } == true
		expect { try self.contains(endpoint, key: "_include", value: "Observation:related-target") } == true
		expect { try self.contains(endpoint, key: "_include", value: "Observation:specimen") } == true
	}
	
	func test_endpoint_soapEntries() throws {
		
		// Given
		
		// When
		let endpoint = DVP.GeneralPractitioner.soapEntries
		
		// Then
		expect(endpoint.path) == "Composition"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect(endpoint.parameters) != nil
		expect { try self.contains(endpoint, key: "type", value: "http://loinc.org|67781-5") } == true
	}
	
	func test_endpoint_encounter() throws {
		
		// Given
		
		// When
		let endpoint = DVP.GeneralPractitioner.encounter
		
		// Then
		expect(endpoint.path) == "Encounter"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect(endpoint.parameters) == nil
	}
}
