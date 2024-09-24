/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import LocalisationService
import MGOTest

final class LocationServiceClientTests: XCTestCase {

	override func tearDown() {
		super.tearDown()
		HTTPStubs.removeAllStubs()
	}
	
	func test_client() async throws {
		
		// Given
		let client = LocalisationServiceClient()
		stub(condition: isPath("/localization/organization/search")) { _ in
			return HTTPStubsResponse(jsonObject: ["organizations": []], statusCode: 200, headers: nil)
		}
		
		// When
		let result = try await client?.searchHealthcareOrganizations(city: "test", name: "test")
		
		// Then
		expect(result).to(beEmpty())
	}
}
