/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import OpenAPIRuntime
import OpenAPIURLSession
import Foundation
import HTTPTypes

public struct AuthenticationMiddleware: ClientMiddleware {
	
	/// The basic auth username
	private var username: String
	
	/// The basic auth password
	private var password: String
	
	/// Create an Authentication Middleware
	/// - Parameters:
	///   - username: the basic auth username
	///   - password: the basic auth password.
	public init(username: String, password: String) {
		self.username = username
		self.password = password
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
		let loginString = String(format: "%@:%@", username, password)
		if let loginData = loginString.data(using: String.Encoding.utf8) {
			let base64LoginString = loginData.base64EncodedString()
			request.headerFields[.authorization] = "Basic \(base64LoginString)"
		}
		return try await next(request, body, baseURL)
	}
}
