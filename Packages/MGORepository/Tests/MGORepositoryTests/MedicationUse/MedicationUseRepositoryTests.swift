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
	
	func test_repository_medicationUse() async throws {
		
		// Given
		let inputJson = try getResource("medication_statement_input_1")
		let url = try XCTUnwrap(URL(string: "https:example.com"))
		let client = try XCTUnwrap(FHIRClient(baseURL: url))
	
		let outputJson = try getResource("medication_statement_output_1")
		let expectedMedication = try JSONDecoder().decode(ZibMedicationUse.self, from: outputJson)

		stub(condition: isPath("/MedicationStatement")) { _ in
			return HTTPStubsResponse(data: inputJson, statusCode: 200, headers: nil)
		}
		
		// When
		let result = try await client.fetchResources(dvaTarget: "test")
		let medicationUseResult = try XCTUnwrap(result.first)
		let medication = ZibFactory.createZibMedicationUse(medicationUseResult)

		// Then
		expect(medication) == expectedMedication
	}
	
	func test_repository_product() async throws {
		
		// Given
		let inputJson = try getResource("medication_statement_input_1")
		let url = try XCTUnwrap(URL(string: "https:example.com"))
		let client = try XCTUnwrap(FHIRClient(baseURL: url))
	
		let outputJson = try getResource("medication_statement_output_2")
		let expectedProduct = try JSONDecoder().decode(ZibProduct.self, from: outputJson)

		stub(condition: isPath("/MedicationStatement")) { _ in
			return HTTPStubsResponse(data: inputJson, statusCode: 200, headers: nil)
		}
		
		// When
		let result = try await client.fetchResources(dvaTarget: "test")
		let productResult = try XCTUnwrap(result.last)
		let product = ZibFactory.createZibProduct(productResult)

		// Then
		expect(product) == expectedProduct
	}
}
