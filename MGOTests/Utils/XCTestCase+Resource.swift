/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest

extension XCTestCase {
	
	/// Get a resource from disc as Data
	/// - Parameters:
	///   - fileName: the name of the file
	///   - fileExtension: the extension of the file, defaults to .json
	/// - Returns: Data
	func getResource(_ fileName: String, fileExtension: String = ".json") throws -> Data {
		
		let bundle = Bundle(for: type(of: self))
		let resourceUrl = try XCTUnwrap(bundle.url(forResource: fileName, withExtension: fileExtension))
		return try Data(contentsOf: resourceUrl)
	}
}

// Used to locate the test bundle from non-class (Swift Testing struct) contexts
private final class _TestBundleLocator: NSObject { /* no-op */ }

/// Get a resource from disc as Data (free function for use in Swift Testing structs)
/// - Parameters:
///   - fileName: the name of the file
///   - fileExtension: the extension of the file, defaults to .json
/// - Returns: Data
func getResource(_ fileName: String, fileExtension: String = ".json") throws -> Data {

	let bundle = Bundle(for: _TestBundleLocator.self)
	guard let resourceUrl = bundle.url(forResource: fileName, withExtension: fileExtension) else {
		throw CocoaError(.fileNoSuchFile)
	}
	return try Data(contentsOf: resourceUrl)
}
