/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import RemoteAuthentication
import MGOTest

final class RemoteAuthenticationClientTests: XCTestCase {
	
	override func tearDown() {
		super.tearDown()
		HTTPStubs.removeAllStubs()
	}
	
	func test_client() async throws {
		
		// Given
		let serverUrl = try XCTUnwrap(URL(string: "https://example.com"))
		let client = RemoteAuthenticationClient(serverUrl: serverUrl, username: nil, password: nil)
		stub(condition: isPath("/oidc/start")) { _ in
			return HTTPStubsResponse(jsonObject: ["authz_url": "https://example.com/callback"], statusCode: 200, headers: nil)
		}
		
		// When
		let result = try await client.getAuthenticationUrl(callbackUrl: "test")
		
		// Then
		expect(result.absoluteString) == "https://example.com/callback"
	}
	
	func test_client_withBasicAuth() async throws {
		
		// Given
		let serverUrl = try XCTUnwrap(URL(string: "https://example.com"))
		let client = RemoteAuthenticationClient(serverUrl: serverUrl, username: "test", password: "test")
		stub(condition: isPath("/oidc/start")) { _ in
			return HTTPStubsResponse(jsonObject: ["authz_url": "https://example.com/callback"], statusCode: 200, headers: nil)
		}
		
		// When
		let result = try await client.getAuthenticationUrl(callbackUrl: "test")
		
		// Then
		expect(result.absoluteString) == "https://example.com/callback"
	}
	
	func test_client_noAuthenticationUrl() async throws {
		
		// Given
		let serverUrl = try XCTUnwrap(URL(string: "https://example.com"))
		let client = RemoteAuthenticationClient(serverUrl: serverUrl, username: "test", password: "test")
		stub(condition: isPath("/oidc/start")) { _ in
			return HTTPStubsResponse(jsonObject: [], statusCode: 200, headers: nil)
		}
		
		// When / Then
		await expect { try await client.getAuthenticationUrl(callbackUrl: "test") }
			.to(throwError(RemoteAuthenticationError.noAuthenticationUrl))
	}
}
