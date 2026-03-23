/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import HTTPTypes
import Foundation
@testable import OpenAPIMiddleware
import Testing

class StripHeaderEncodingMiddlewareTests {
	
	// MARK: - Nominated headers
	
	@Test("Percent-encoded value on a nominated header is decoded")
	func nominatedHeader_percentEncodedValue_isDecoded() async throws {
		
		// Given
		let url = try #require(URL(string: "https://example.com"))
		let middleware = StripHeaderEncodingMiddleware(strippableHeaders: [.ifNoneMatch])
		var request = HTTPRequest(method: .get, scheme: nil, authority: nil, path: nil)
		request.headerFields[.ifNoneMatch] = "%22abc123%22"
		nonisolated(unsafe) var capturedValue: String?
		
		// When
		_ = try await middleware.intercept(request, body: nil, baseURL: url, operationID: "test") { req, _, _ in
			capturedValue = req.headerFields[.ifNoneMatch]
			return (HTTPResponse(status: 200), nil)
		}
		
		// Then
		#expect(capturedValue == "\"abc123\"")
	}
	
	@Test("Already-decoded value on a nominated header is passed through unchanged")
	func nominatedHeader_plainValue_isPassedThrough() async throws {
		
		// Given
		let url = try #require(URL(string: "https://example.com"))
		let middleware = StripHeaderEncodingMiddleware(strippableHeaders: [.ifNoneMatch])
		var request = HTTPRequest(method: .get, scheme: nil, authority: nil, path: nil)
		request.headerFields[.ifNoneMatch] = "\"abc123\""
		nonisolated(unsafe) var capturedValue: String?
		
		// When
		_ = try await middleware.intercept(request, body: nil, baseURL: url, operationID: "test") { req, _, _ in
			capturedValue = req.headerFields[.ifNoneMatch]
			return (HTTPResponse(status: 200), nil)
		}
		
		// Then
		#expect(capturedValue == "\"abc123\"")
	}
	
	// MARK: - Non-nominated headers
	
	@Test("Percent-encoded value on a non-nominated header is not decoded")
	func nonNominatedHeader_percentEncodedValue_isNotDecoded() async throws {
		
		// Given
		let url = try #require(URL(string: "https://example.com"))
		let middleware = StripHeaderEncodingMiddleware(strippableHeaders: [.ifNoneMatch])
		var request = HTTPRequest(method: .get, scheme: nil, authority: nil, path: nil)
		request.headerFields[.ifMatch] = "%22abc123%22"
		nonisolated(unsafe) var capturedValue: String?
		
		// When
		_ = try await middleware.intercept(request, body: nil, baseURL: url, operationID: "test") { req, _, _ in
			capturedValue = req.headerFields[.ifMatch]
			return (HTTPResponse(status: 200), nil)
		}
		
		// Then
		#expect(capturedValue == "%22abc123%22")
	}
	
	// MARK: - Empty strippable headers
	
	@Test("No headers are modified when strippableHeaders is empty")
	func emptyStrippableHeaders_noHeadersModified() async throws {
		
		// Given
		let url = try #require(URL(string: "https://example.com"))
		let middleware = StripHeaderEncodingMiddleware(strippableHeaders: [])
		var request = HTTPRequest(method: .get, scheme: nil, authority: nil, path: nil)
		request.headerFields[.ifNoneMatch] = "%22abc123%22"
		nonisolated(unsafe) var capturedValue: String?
		
		// When
		_ = try await middleware.intercept(request, body: nil, baseURL: url, operationID: "test") { req, _, _ in
			capturedValue = req.headerFields[.ifNoneMatch]
			return (HTTPResponse(status: 200), nil)
		}
		
		// Then
		#expect(capturedValue == "%22abc123%22")
	}
	
	// MARK: - Multiple headers
	
	@Test("Only nominated headers are decoded when multiple headers are present")
	func multipleHeaders_onlyNominatedAreDecoded() async throws {
		
		// Given
		let url = try #require(URL(string: "https://example.com"))
		let middleware = StripHeaderEncodingMiddleware(strippableHeaders: [.ifNoneMatch])
		var request = HTTPRequest(method: .get, scheme: nil, authority: nil, path: nil)
		request.headerFields[.ifNoneMatch] = "%22abc123%22"
		request.headerFields[.ifMatch] = "%22xyz%22"
		nonisolated(unsafe) var capturedIfNoneMatch: String?
		nonisolated(unsafe) var capturedIfMatch: String?
		
		// When
		_ = try await middleware.intercept(request, body: nil, baseURL: url, operationID: "test") { req, _, _ in
			capturedIfNoneMatch = req.headerFields[.ifNoneMatch]
			capturedIfMatch = req.headerFields[.ifMatch]
			return (HTTPResponse(status: 200), nil)
		}
		
		// Then
		#expect(capturedIfNoneMatch == "\"abc123\"")
		#expect(capturedIfMatch == "%22xyz%22")
	}
}
