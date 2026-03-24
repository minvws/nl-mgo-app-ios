/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import HTTPTypes
import Foundation
@testable import OpenAPIMiddleware
import Testing

class AuthorizationMiddlewareTests {

	@Test("Basic authentication should set the correct Authorization header")
	func test_basicAuthentication() async throws {

		// Given
		let middleware = AuthorizationMiddleware(username: "test", password: "test")
		let url = try #require(URL(string: "https://example.com"))
		let request = HTTPRequest(method: .get, scheme: nil, authority: nil, path: nil)
		nonisolated(unsafe) var capturedValue: String?

		// When
		_ = try await middleware.intercept(request, body: nil, baseURL: url, operationID: "test") { req, _, _ in
			capturedValue = req.headerFields[.authorization]
			return (HTTPResponse(status: 200), nil)
		}

		// Then
		#expect(capturedValue == "Basic dGVzdDp0ZXN0")
	}

	@Test("Bearer authentication should set the correct Authorization header")
	func test_bearerAuthentication() async throws {

		// Given
		let middleware = AuthorizationMiddleware(token: "test")
		let url = try #require(URL(string: "https://example.com"))
		let request = HTTPRequest(method: .get, scheme: nil, authority: nil, path: nil)
		nonisolated(unsafe) var capturedValue: String?

		// When
		_ = try await middleware.intercept(request, body: nil, baseURL: url, operationID: "test") { req, _, _ in
			capturedValue = req.headerFields[.authorization]
			return (HTTPResponse(status: 200), nil)
		}

		// Then
		#expect(capturedValue == "Bearer test")
	}
}
