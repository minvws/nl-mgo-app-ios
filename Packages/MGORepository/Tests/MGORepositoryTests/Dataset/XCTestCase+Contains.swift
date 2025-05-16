/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import MGOTest
@testable import FHIRClient

extension XCTestCase {
	
	/// Check if the endpoint contains a request param key van value
	/// - Parameters:
	///   - endpoint: the endpoint to check
	///   - key: the expected key
	///   - value: the expected value
	/// - Returns: True if the params are contained.
	func contains(_ endpoint: DVP.Endpoint, key: String, value: String) throws -> Bool {
		var success = false
		for (actualKey, actualValue) in try XCTUnwrap(endpoint.parameters).parameters where actualKey.rawValue == key && actualValue == value {
			success = true
		}
		return success
	}
}
