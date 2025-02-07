/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import OpenAPIRuntime
import Foundation
import HTTPTypes

public struct BearerAuthorizationMiddleware: ClientMiddleware {
	
	/// The bearer token
	private var token: String
	
	/// Create a Bearer Authorization Middleware
	/// - Parameters:
	///   - token: the bearer token
	public init(token: String) {
		self.token = token
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
		request.headerFields[.authorization] = "Bearer \(token)"
		return try await next(request, body, baseURL)
	}
}
