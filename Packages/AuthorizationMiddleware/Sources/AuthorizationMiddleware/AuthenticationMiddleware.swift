/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import OpenAPIRuntime
import Foundation
import HTTPTypes

public struct AuthorizationMiddleware: ClientMiddleware {
	
	/// The auth field
	private var authorization: String?
	
	/// Create a Basic Auth Authorization Middleware
	/// - Parameters:
	///   - username: the basic auth username
	///   - password: the basic auth password.
	public init(username: String, password: String) {
		
		let loginString = String(format: "%@:%@", username, password)
		if let loginData = loginString.data(using: String.Encoding.utf8) {
			let base64LoginString = loginData.base64EncodedString()
			authorization = "Basic \(base64LoginString)"
		}
	}
	
	/// Create a Bearer Authorization Middleware
	/// - Parameters:
	///   - token: the bearer token
	public init(token: String) {
		authorization = "Bearer \(token)"
	}
	
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
		
		var request = request
		if let authorization {
			request.headerFields[.authorization] = authorization
		}
		return try await next(request, body, baseURL)
	}
}
