/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import MGOTest
import FHIRClient

final class LaboratoryTestResultsRepositoryTests: XCTestCase {
	
	override func tearDown() {
		super.tearDown()
		HTTPStubs.removeAllStubs()
	}
	
	func test_repository() async throws {
		
		// Given
		let inputJson = try getResource("observation_input")
		let client = try XCTUnwrap(FHIRClient())
	
		let outputJson = try getResource("observation_output")
		let expectedResult = try JSONDecoder().decode([MgoLaboratoryTestResult].self, from: outputJson)

		stub(condition: isPath("/fhir/Observation/$lastn")) { _ in
			return HTTPStubsResponse(data: inputJson, statusCode: 200, headers: nil)
		}
		
		// When
		let results = try await client.fetchResults()
		
		// Then
		await expect(results).toEventually(haveCount(1))
		expect(results) == expectedResult
	}
}
