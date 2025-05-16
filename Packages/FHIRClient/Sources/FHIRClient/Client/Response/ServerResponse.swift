/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/**
Encapsulates a server response, which can also indicate that there was no response or not even a request, in which case the `error`
property carries the only useful information.
*/
public protocol ServerResponse {
	
	/// The HTTP status code.
	var status: Int { get }
	
	/// Response headers.
	var headers: [String: String] { get }
	
	/// The response body data.
	var body: Data? { get }
	
	/// The error encountered, if any.
	var error: FHIRError? { get }
}
