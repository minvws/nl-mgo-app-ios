/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import LocalisationService
import MGOTest
import HTTPTypes

final class AuthenticationMiddlewareTests: XCTestCase {

	var actualAuth: String? = ""

	func test_authentication() async throws {
		
		// Given
		let middleware = AuthenticationMiddleware(username: "test", password: "test")
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
}
