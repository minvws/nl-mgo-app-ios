/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */
import Foundation

extension ServerResponse {
	
	/// Nicely format status code, response headers and response body (if any).
	public var debugDescription: String {
		var msg = "HTTP 1.1 \(status)"
		headers.forEach { msg += "\n\($0): \($1)" }
		if let body = body, !body.isEmpty {
			msg += "\n\n\(NSString(data: body as Data, encoding: String.Encoding.utf8.rawValue) ?? "")"
		}
		return msg
	}
}
