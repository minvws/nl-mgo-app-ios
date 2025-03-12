/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import MGOTest
import FHIRClient

final class DocumentTests: XCTestCase {
	
	func test_endpoint_reference() throws {
		
		// Given
		
		// When
		let endpoint = DVP.Documents.documentReference
		
		// Then
		expect(endpoint.path) == "DocumentReference"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect(endpoint.parameters) == nil
	}
}
