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
		let endpoint = DVP.Documents.documentReference
		
		// When
		
		// Then
		expect(endpoint.path) == "DocumentReference"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "status", value: "current") } == true
	}
	
	func test_endpoint_manifest() throws {
		
		// Given
		let endpoint = DVP.Documents.documentManifest
		
		// When
		
		// Then
		expect(endpoint.path) == "DocumentManifest"
		expect(endpoint.directory) == nil
		expect(endpoint.fhirVersion) == .r3
		expect { try self.contains(endpoint, key: "status", value: "current") } == true
	}
}
