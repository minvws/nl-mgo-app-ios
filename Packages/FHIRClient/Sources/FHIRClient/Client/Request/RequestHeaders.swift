/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/**
Struct to hold request headers. By default, the "Accept-Charset" header is set to "utf-8" upon initialization.
*/
public struct RequestHeaders {
	
	/// All the headers the instance is holding on to.
	public var headers: [RequestHeaderField: String]
	
	/// Initializer
	/// - Parameter headers: the headers
	public init(_ headers: [RequestHeaderField: String]? = nil) {
		var hdrs = [RequestHeaderField.acceptCharset: "utf-8"]
		headers?.forEach { hdrs[$0] = $1 }
		self.headers = hdrs
	}
	
	public subscript(key: RequestHeaderField) -> String? {
		get { return headers[key] }
		set { headers[key] = newValue }
	}
	
	/**
	Prepare a given mutable URL request with the receiver's values.
	*/
	public func prepare(request: inout URLRequest) {
		headers.forEach {
			request.setValue($1, forHTTPHeaderField: $0.rawValue)
		}
	}
}

/**
Describe valid (and supported) FHIR request headers.

The "Authorization" header is not used in the basic library, it is provided for convenience's sake.
*/
public enum RequestHeaderField: String {
	case accept          = "Accept"
	case acceptCharset   = "Accept-Charset"
	case authorization   = "Authorization"
	case contentType     = "Content-Type"
	case prefer          = "Prefer"
	case ifMatch         = "If-Match"
	case ifNoneMatch     = "If-None-Match"
	case ifModifiedSince = "If-Modified-Since"
	case ifNoneExist     = "If-None-Exist"
	case dvaTarget       = "x-mgo-dva-target"
}
