/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import FHIRClient
import XCTest

extension XCTestCase {
	
	func getResource(_ fileName: String, fileExtension: String = ".json", bundle: Foundation.Bundle = Foundation.Bundle.module) throws -> FHIRJSON {
		
		let resourceUrl = try XCTUnwrap(bundle.url(forResource: fileName, withExtension: fileExtension))
		let data = try Data(contentsOf: resourceUrl)
		let json = try JSONSerialization.jsonObject(with: data, options: []) as? FHIRJSON
		
		if let json = json {
			return json
		}
		throw FHIRError.error("Unable to decode «\(resourceUrl)» to JSON")
	}
}
