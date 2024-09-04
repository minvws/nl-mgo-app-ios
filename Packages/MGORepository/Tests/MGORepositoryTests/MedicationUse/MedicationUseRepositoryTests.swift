/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import MGOTest
import FHIRClient
import Zibs

final class MedicationUseRepositoryTests: XCTestCase {
	
	override func tearDown() {
		super.tearDown()
		HTTPStubs.removeAllStubs()
	}
	
	func test_repository() async throws {
		
//		// Given
//		let inputJson = try getResource("medication_statement_input_1")
//		let client = try XCTUnwrap(FHIRClient())
//	
//		let outputJson = try getResource("medication_statement_output_1")
//		let expectedMedication = try JSONDecoder().decode(ZibMedicationUse.self, from: outputJson)
//
//		stub(condition: isPath("/fhir/MedicationStatement")) { _ in
//			return HTTPStubsResponse(data: inputJson, statusCode: 200, headers: nil)
//		}
//		
//		// When
//		let result = try await client.fetchMedicationUse(dvaTarget: "test")
//
//		// Then
//		await expect(result.first?.schema?.label).toEventually(equal("Zestril tablet 10mg"))
//		expect(result.first?.zib as? ZibMedicationUse) == expectedMedication
	}
}
