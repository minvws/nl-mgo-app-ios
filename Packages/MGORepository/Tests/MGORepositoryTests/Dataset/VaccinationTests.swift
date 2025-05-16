/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import MGOTest
import FHIRClient

final class VaccinationTests: XCTestCase {
	
	func test_endpoint() throws {
		
		// Given
		
		// When
		let endpoint = DVP.Vaccination.patient
		
		// Then
		expect(endpoint.path) == "Immunization"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r4
		expect(endpoint.parameters) == nil
	}
}
