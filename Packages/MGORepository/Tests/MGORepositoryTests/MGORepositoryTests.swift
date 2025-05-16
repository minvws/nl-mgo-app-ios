/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import MGOTest
import FHIRClient

final class MGORepositoryTests: XCTestCase {
	
	var sut: MGORepository!

	override func setUpWithError() throws {
		
		try super.setUpWithError()
		
		let serverUrl = try XCTUnwrap(URL(string: "https://example.com"))
		let client = FHIRClient(baseURL: serverUrl)
		sut = MGORepository(client: client)
	}
	
	override func tearDown() {
		super.tearDown()
		HTTPStubs.removeAllStubs()
	}

	func test_getBundleData_fhir3() async throws {
		
		// Given
		let json = try getResource("bundle")
		let endpoint = DVP.Endpoint(
			path: "TestPath",
			parameters: RequestParameters([(RequestParameterField.include, "test")]),
			directory: "TestDirectory",
			serviceId: "TestServiceId",
			fhirVersion: .r3
		)
		stub(condition: isPath("/TestPath/TestDirectory")) { request in
			expect(request.allHTTPHeaderFields?["Accept"]) == "application/json+fhir; fhirVersion=3.0"
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		let data = try await sut.getBundleData(endpoint: endpoint, dvaTarget: "test", username: nil, password: nil)
		
		// Then
		expect(data) == json
	}
	
	func test_getBundleData_fhir4() async throws {
		
		// Given
		let json = try getResource("bundle")
		let endpoint = DVP.Endpoint(
			path: "TestPath",
			parameters: RequestParameters([(RequestParameterField.include, "test")]),
			directory: "TestDirectory",
			serviceId: "TestServiceId",
			fhirVersion: .r4
		)
		stub(condition: isPath("/TestPath/TestDirectory")) { request in
			expect(request.allHTTPHeaderFields?["Accept"]) == "application/json+fhir; fhirVersion=4.0"
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		let data = try await sut.getBundleData(endpoint: endpoint, dvaTarget: "test", username: nil, password: nil)
		
		// Then
		expect(data) == json
	}
}
