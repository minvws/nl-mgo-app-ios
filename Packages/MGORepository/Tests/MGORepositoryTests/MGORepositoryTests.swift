/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
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
	
	func test_getBundle() async throws {
		
		// Given
		let json = try getResource("bundle")
		stub(condition: isPath("/MedicationStatement")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		let resource = try await sut.getBundle(endpoint: DVP.CommonClinicalDataset.medicationUse, dvaTarget: "test")
		
		// Then
		expect(resource?.id?.value?.string) == "4f0c7257-c18e-4d3d-9c1e-aa2b2ed4ebb3"
		expect(resource?.type.value?.rawValue) == "searchset"
	}

	func test_getBundleData() async throws {
		
		// Given
		let json = try getResource("bundle")
		let endpoint = DVP.Endpoint(
			path: "TestPath",
			parameters: RequestParameters([(RequestParameterField.include, "test")]),
			directory: "TestDirectory"
		)
		stub(condition: isPath("/TestPath/TestDirectory")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		let data = try await sut.getBundleData(endpoint: endpoint, dvaTarget: "test")
		
		// Then
		expect(data) == json
	}
}
