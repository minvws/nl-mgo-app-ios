/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import XCTest

extension XCTestCase {
	
	/// Get a resource from disc as Data
	/// - Parameters:
	///   - fileName: the name of the file
	///   - fileExtension: the extension of the file, defaults to .json
	///   - bundle: the bundle to read from, defaults to .module
	/// - Returns: Data
	func getResource(_ fileName: String, fileExtension: String = ".json", bundle: Foundation.Bundle = Foundation.Bundle.module) throws -> Data {
		
		let resourceUrl = try XCTUnwrap(bundle.url(forResource: fileName, withExtension: fileExtension))
		return try Data(contentsOf: resourceUrl)
	}
}
