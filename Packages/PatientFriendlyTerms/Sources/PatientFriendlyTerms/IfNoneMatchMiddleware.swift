/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import OpenAPIRuntime
import Foundation
import HTTPTypes

public struct IfNoneMatchMiddleware: ClientMiddleware {
	
	/// The ETag value
	private var eTag: String?
	
	/// Create an if none match Middleware
	/// - Parameters:
	///   - token: the bearer token
	public init(eTag: String?) {
		self.eTag = eTag
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
		if let eTag {
			request.headerFields[values: .ifNoneMatch] = [eTag]
		}
		
		return try await next(request, body, baseURL)
	}
}
