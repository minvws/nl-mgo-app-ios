/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import MGOTest
import FHIRClient

final class GeneralPractitionerTests: XCTestCase {
	
	func test_endpoint_patient() throws {
		
		// Given
		let endpoint = DVP.GeneralPractitioner.patient
		
		// When
		
		// Then
		expect(endpoint.path) == "Patient"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "_include", value: "Patient:general-practitioner") } == true
	}
	
	func test_endpoint_episodes() throws {
		
		// Given
		let endpoint = DVP.GeneralPractitioner.episodes
		
		// When
		
		// Then
		expect(endpoint.path) == "EpisodeOfCare"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect(endpoint.parameters) == nil
	}
	
	func test_endpoint_currentMedication() throws {
		
		// Given
		let endpoint = DVP.GeneralPractitioner.currentMedication
		
		// When
		
		// Then
		expect(endpoint.path) == "MedicationRequest"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "periodofuse", value: "ge[today]") } == true
		expect { try self.contains(endpoint, key: "category", value: "http://snomed.info/sct|16076005") } == true
		expect { try self.contains(endpoint, key: "_include", value: "MedicationRequest:medication") } == true
	}
	
	func test_endpoint_allergyIntolerance() throws {
		
		// Given
		let endpoint = DVP.GeneralPractitioner.allergyIntolerance
		
		// When
		
		// Then
		expect(endpoint.path) == "AllergyIntolerance"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "category", value: "medication") } == true
	}
	
	func test_endpoint_diagnosticAndLabResults() throws {
		
		// Given
		let endpoint = DVP.GeneralPractitioner.diagnosticAndLabResults
		
		// When
		
		// Then
		expect(endpoint.path) == "Observation"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "code", value: "https://referentiemodel.nhg.org/tabellen/nhg-tabel-45-diagnostische-bepalingen|") } == true
		expect { try self.contains(endpoint, key: "_include", value: "Observation:related-target") } == true
		expect { try self.contains(endpoint, key: "_include", value: "Observation:specimen") } == true
		expect { try self.contains(endpoint, key: "date", value: "ge2017-01-01") } == true
	}
	
	func test_endpoint_soapEntries() throws {
		
		// Given
		let endpoint = DVP.GeneralPractitioner.soapEntries
		
		// When
		
		// Then
		expect(endpoint.path) == "Composition"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "type", value: "http://loinc.org|67781-5") } == true
	}
	
	func test_endpoint_encounter() throws {
		
		// Given
		let endpoint = DVP.GeneralPractitioner.encounter
		
		// When
		
		// Then
		expect(endpoint.path) == "Encounter"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect(endpoint.parameters) == nil
	}
}
