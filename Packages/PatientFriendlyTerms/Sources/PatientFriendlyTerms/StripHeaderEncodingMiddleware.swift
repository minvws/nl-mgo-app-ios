/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import OpenAPIRuntime
import Foundation
import HTTPTypes

public struct StripHeaderEncodingMiddleware: ClientMiddleware {
	
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
				if let fixed = field.value.removingPercentEncoding {
					HTTPField(name: field.name, value: fixed)
				} else {
					field
				}
			}
		)
		return try await next(modifiedRequest, body, baseURL)
	}
}
