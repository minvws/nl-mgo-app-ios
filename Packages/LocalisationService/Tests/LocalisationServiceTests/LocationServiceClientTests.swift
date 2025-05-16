/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
		let serverUrl = try XCTUnwrap(URL(string: "https://example.com"))
		let client = LocalisationServiceClient(serverUrl: serverUrl, username: nil, password: nil)
		stub(condition: isPath("/localization/organization/search")) { _ in
			return HTTPStubsResponse(jsonObject: ["organizations": []], statusCode: 200, headers: nil)
		}
		
		// When
		let result = try await client.searchHealthcareOrganizations(city: "test", name: "test")
		
		// Then
		expect(result).to(beEmpty())
	}
	
	func test_client_withBasicAuth() async throws {
		
		// Given
		let serverUrl = try XCTUnwrap(URL(string: "https://example.com"))
		let client = LocalisationServiceClient(serverUrl: serverUrl, username: "test", password: "test")
		stub(condition: isPath("/localization/organization/search")) { _ in
			return HTTPStubsResponse(jsonObject: ["organizations": []], statusCode: 200, headers: nil)
		}
		
		// When
		let result = try await client.searchHealthcareOrganizations(city: "test", name: "test")
		
		// Then
		expect(result).to(beEmpty())
	}
	
	func test_client_demo() async throws {
		
		// Given
		let serverUrl = try XCTUnwrap(URL(string: "https://example.com"))
		let client = LocalisationServiceClient(serverUrl: serverUrl, username: "test", password: "test")
		stub(condition: isPath("/localization/organization/search-demo")) { _ in
			return HTTPStubsResponse(jsonObject: ["organizations": []], statusCode: 200, headers: nil)
		}
		
		// When
		let result = try await client.searchDemoOrganizations()
		
		// Then
		expect(result).to(beEmpty())
	}
}
