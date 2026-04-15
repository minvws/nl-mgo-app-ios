/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import Testing

/// Get a resource from disc as Data
/// - Parameters:
///   - fileName: the name of the file
///   - fileExtension: the extension of the file, defaults to .md
///   - bundle: the bundle to read from, defaults to .module
/// - Returns: Data
func getResource(_ fileName: String, fileExtension: String = ".md", bundle: Foundation.Bundle = Foundation.Bundle.module) throws -> Data {

	let resourceUrl = try #require(bundle.url(forResource: fileName, withExtension: fileExtension))
	return try Data(contentsOf: resourceUrl)
}
