/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */
import Foundation

extension ServerResponse {
	
	/**
	The base implementation inspects response headers ( "ETag") and updates the resource's `id` and `meta`
	accordingly.
	
	This method must not be called if the response has a non-nil error.
	
	- parameter resource: The resource to apply response data to
	*/
	public func applyHeaders(to resource: Resource, baseURL: URL) throws {
		
		// inspect ETag header
		if var etag = headers["ETag"] {
			resource.meta = resource.meta ?? Meta()
			if resource.meta?.versionId == nil {
				if etag.hasPrefix("W/") {
					etag = String(etag[etag.index(etag.startIndex, offsetBy: 2)..<etag.endIndex])
				}
				if etag.hasPrefix("\"") {
					etag = String(etag[etag.index(etag.startIndex, offsetBy: 1)..<etag.endIndex])
				}
				if etag.hasSuffix("\"") {
					etag = String(etag[etag.startIndex..<etag.index(etag.endIndex, offsetBy: -1)])
				}
				resource.meta?.versionId = etag.asFHIRStringPrimitive()
			}
		}
	}
	
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
