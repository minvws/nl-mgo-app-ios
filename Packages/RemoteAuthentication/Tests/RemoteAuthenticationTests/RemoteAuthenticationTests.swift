/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import RemoteAuthentication
import Testing
import OHHTTPStubs
import OHHTTPStubsSwift

class RemoteAuthenticationTests {
	
	deinit {
		HTTPStubs.removeAllStubs()
	}
	
	@Test
	func client() async throws {
		
		// Given
		let serverUrl = try #require(URL(string: "https://example.com"))
		let client = RemoteAuthenticationClient(serverUrl: serverUrl)
		stub(condition: isPath("/oidc/start")) { _ in
			return HTTPStubsResponse(
				jsonObject: ["authz_url": "https://example.com/callback"],
				statusCode: 200,
				headers: nil
			)
		}
		
		// When
		let result = try await client.getAuthenticationUrl(callbackUrl: "test")
		
		// Then
		#expect(result.absoluteString == "https://example.com/callback")
	}
	
	@Test
	func client_withBasicAuth() async throws {
		
		// Given
		let serverUrl = try #require(URL(string: "https://example.com"))
		let client = RemoteAuthenticationClient(
			serverUrl: serverUrl,
			username: "test",
			password: "test"
		)
		stub(condition: isPath("/oidc/start")) { _ in
			return HTTPStubsResponse(
				jsonObject: ["authz_url": "https://example.com/callback"],
				statusCode: 200,
				headers: nil
			)
		}
		
		// When
		let result = try await client.getAuthenticationUrl(callbackUrl: "test")
		
		// Then
		#expect(result.absoluteString == "https://example.com/callback")
	}
	
	@Test
	func client_noAuthenticationUrl() async throws {
		
		// Given
		let serverUrl = try #require(URL(string: "https://example.com"))
		let client = RemoteAuthenticationClient(serverUrl: serverUrl)
		stub(condition: isPath("/oidc/start")) { _ in
			return HTTPStubsResponse(
				jsonObject: [],
				statusCode: 200,
				headers: nil
			)
		}
		
		// Then
		await #expect(throws: RemoteAuthenticationError.noAuthenticationUrl.self) {
			
			// When
			try await client.getAuthenticationUrl(callbackUrl: "test")
		}
	}
}
