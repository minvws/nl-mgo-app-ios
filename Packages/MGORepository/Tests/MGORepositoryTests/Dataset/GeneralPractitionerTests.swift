/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import MGOTest
import FHIRClient

final class VaccinationTests: XCTestCase {
	
	func test_endpoint_patient() throws {
		
		// Given
		let endpoint = DVP.Vaccination.patient
		
		// When
		
		// Then
		expect(endpoint.path) == "Immunization"
		expect(endpoint.directory) == nil
		expect { try self.contains(endpoint, key: "_include", value: "patient") } == true
	}
	
	func test_endpoint_location() throws {
		
		// Given
		let endpoint = DVP.Vaccination.location
		
		// When
		
		// Then
		expect(endpoint.path) == "Immunization"
		expect(endpoint.directory) == nil
		expect { try self.contains(endpoint, key: "_include", value: "location") } == true
	}
	
	func test_endpoint_performer() throws {
		
		// Given
		let endpoint = DVP.Vaccination.performer
		
		// When
		
		// Then
		expect(endpoint.path) == "Immunization"
		expect(endpoint.directory) == nil
		expect { try self.contains(endpoint, key: "_include", value: "performer") } == true
	}

}
