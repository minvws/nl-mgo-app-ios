/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import MGOTest
import FHIRClient

final class ConcernRepositoryTests: XCTestCase {
	
	override func tearDown() {
		super.tearDown()
		HTTPStubs.removeAllStubs()
	}
	
	func test_repository() async throws {
		
		// Given
		let inputJson = try getResource("concern_input")
		let client = try XCTUnwrap(FHIRClient())
	
		let outputJson = try getResource("concern_output")
		let expectedConcerns = try JSONDecoder().decode([MgoConcern].self, from: outputJson)

		stub(condition: isPath("/fhir/Condition")) { _ in
			return HTTPStubsResponse(data: inputJson, statusCode: 200, headers: nil)
		}
		
		// When
		let concerns = try await client.fetchConcerns()
		
		// Then
		await expect(concerns).toEventually(haveCount(1))
		expect(concerns) == expectedConcerns
	}
}
