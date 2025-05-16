/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import AuthorizationMiddleware
import MGOTest
import HTTPTypes

final class AuthorizationMiddlewareTests: XCTestCase {

	var actualAuth: String? = ""

	func test_basicAuthentication() async throws {
		
		// Given
		let middleware = AuthorizationMiddleware(username: "test", password: "test")
		let url = try XCTUnwrap( URL(string: "https://example.com") )
		let request = HTTPRequest(method: HTTPRequest.Method.get, scheme: nil, authority: nil, path: nil)
		
		// When
		_ = try await middleware.intercept(request, body: nil, baseURL: url, operationID: "test") { req, _, _ in
			actualAuth = req.headerFields[.authorization]
			return (HTTPResponse(status: 200), nil)
		}
		
		// Then
		await expect(self.actualAuth).toEventually(equal("Basic dGVzdDp0ZXN0"))
	}
	
	func test_bearerAuthentication() async throws {
		
		// Given
		let middleware = AuthorizationMiddleware(token: "test")
		let url = try XCTUnwrap( URL(string: "https://example.com") )
		let request = HTTPRequest(method: HTTPRequest.Method.get, scheme: nil, authority: nil, path: nil)
		
		// When
		_ = try await middleware.intercept(request, body: nil, baseURL: url, operationID: "test") { req, _, _ in
			actualAuth = req.headerFields[.authorization]
			return (HTTPResponse(status: 200), nil)
		}
		
		// Then
		await expect(self.actualAuth).toEventually(equal("Bearer test"))
	}
}
