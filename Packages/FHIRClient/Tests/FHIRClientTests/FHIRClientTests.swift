/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import FHIRClient

class FHIRClientTests: XCTestCase {
	
	override func tearDown() {
		super.tearDown()
		HTTPStubs.removeAllStubs()
	}
	
	func test_readDataFrom_success() async throws {
		
		// Given
		let serverUrl = try XCTUnwrap(URL(string: "https://example.com"))
		let client = FHIRClient(baseURL: serverUrl)
		let parameters = RequestParameters(
			[
				(RequestParameterField.category, "urn:oid:2.16.840.1.113883.2.4.3.11.60.20.77.5.3|6"),
				(RequestParameterField.include, "MedicationStatement:medication")
			]
		)
		stub(condition: isPath("/MedicationStatement")) { _ in
			return HTTPStubsResponse(data: Data("success".utf8), statusCode: 200, headers: nil)
		}
		
		// When
		let data = try await client.readDataFrom(
			"MedicationStatement",
			parameters: parameters,
			options: [],
			headers: RequestHeaders([RequestHeaderField.dvaTarget: "dvaTarget"])
		)
		
		// Then
		expect(data) == Data("success".utf8)
	}
	
	func test_readDataFrom_error() async throws {
		
		// Given
		let serverUrl = try XCTUnwrap(URL(string: "https://example.com"))
		let client = FHIRClient(baseURL: serverUrl)
		let parameters = RequestParameters(
			[
				(RequestParameterField.category, "urn:oid:2.16.840.1.113883.2.4.3.11.60.20.77.5.3|6"),
				(RequestParameterField.include, "MedicationStatement:medication")
			]
		)
		stub(condition: isPath("/MedicationStatement")) { _ in
			let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.timedOut.rawValue)
			return HTTPStubsResponse(error: notConnectedError)
		}
		
		// When
		
		// Then
		await expect { try await client.readDataFrom(
			"MedicationStatement",
			parameters: parameters,
			options: [],
			headers: RequestHeaders([RequestHeaderField.dvaTarget: "dvaTarget"]))
		}
		.to( throwError())
	}
	
	func test_readResourceFrom() async throws {
		
		// Given
		let json = try getResource("bundle")
		let serverUrl = try XCTUnwrap(URL(string: "https://example.com"))
		let client = FHIRClient(baseURL: serverUrl)
		let parameters = RequestParameters(
			[
				(RequestParameterField.category, "urn:oid:2.16.840.1.113883.2.4.3.11.60.20.77.5.3|6"),
				(RequestParameterField.include, "MedicationStatement:medication")
			]
		)
		stub(condition: isPath("/MedicationStatement")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		let resource = try await ModelsSTU3.Resource.readResourceFrom(
			"MedicationStatement",
			client: client,
			parameters: parameters,
			options: [],
			headers: RequestHeaders([RequestHeaderField.dvaTarget: "dvaTarget"])
		)
		
		// Then
		expect(resource.id?.value?.string) == "4f0c7257-c18e-4d3d-9c1e-aa2b2ed4ebb3"
	}
}
