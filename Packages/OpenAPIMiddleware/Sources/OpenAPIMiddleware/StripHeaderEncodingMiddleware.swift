/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import OpenAPICore
import Foundation
import HTTPTypes

public struct StripHeaderEncodingMiddleware: ClientMiddleware {
	
	public init(strippableHeaders: [HTTPField.Name] = []) {
		self.strippableHeaders = strippableHeaders
	}
	
	/// All the headers where the encoding should be stripped.
	var strippableHeaders: [HTTPField.Name] = []

	/// Intercepts an outgoing HTTP request and an incoming HTTP response.
	/// - Parameters:
	///   - request: An HTTP request.
	///   - body: An HTTP request body.
	///   - baseURL: A server base URL.
	///   - operationID: The identifier of the OpenAPI operation.
	///   - next: A closure that calls the next middleware, or the transport.
	/// - Returns: An HTTP response and its body.
	/// - Throws: An error if interception of the request and response fails.
	public func intercept(
		_ request: HTTPRequest,
		body: HTTPBody?,
		baseURL: URL,
		operationID: String,
		next: @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
	) async throws -> (HTTPResponse, HTTPBody?) {

		var modifiedRequest = request
		modifiedRequest.headerFields = HTTPFields(
			request.headerFields.map { field in
				if strippableHeaders.contains(field.name),
				   let fixed = field.value.removingPercentEncoding {
					HTTPField(name: field.name, value: fixed)
				} else {
					field
				}
			}
		)
		return try await next(modifiedRequest, body, baseURL)
	}
}
