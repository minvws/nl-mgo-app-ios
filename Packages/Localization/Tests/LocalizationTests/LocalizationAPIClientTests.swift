/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
@testable import Localization
import OHHTTPStubs
import OHHTTPStubsSwift

class LocalizationAPIClientTests {

	deinit {
		HTTPStubs.removeAllStubs()
	}

	// MARK: - getOrganizations

	@Test("getOrganizations returns 200 with data and ETag")
	func getOrganizations_200_response() async throws {

		// Given
		let jsonData = Data("[]".utf8)
		stub(condition: isPath("/static/search/organizations.json")) { _ in
			HTTPStubsResponse(
				data: jsonData,
				statusCode: 200,
				headers: [
					"ETag": "\"abc123\"",
					"Content-Type": "application/json"
				]
			)
		}
		let serverURL = try LocalizationServers.Server.testUrl()
		let sut = LocalizationAPIClient(serverURL)

		// When
		let result = try await sut.fetch(.organizations, eTag: nil)

		// Then
		#expect(result.statusCode == 200)
		#expect(result.eTag == "\"abc123\"")
		#expect(result.data == jsonData)
	}

	@Test("getOrganizations with Basic Auth returns 200")
	func getOrganizations_withBasicAuth_200_response() async throws {

		// Given
		let jsonData = Data("[]".utf8)
		stub(condition: isPath("/static/search/organizations.json")) { _ in
			HTTPStubsResponse(
				data: jsonData,
				statusCode: 200,
				headers: [
					"ETag": "\"xyz\"",
					"Content-Type": "application/json"
				]
			)
		}
		let serverURL = try LocalizationServers.Server.testUrl()
		let sut = LocalizationAPIClient(
			serverURL,
			username: "user",
			password: "pass"
		)

		// When
		let result = try await sut.fetch(.organizations, eTag: nil)

		// Then
		#expect(result.statusCode == 200)
		#expect(result.data == jsonData)
	}

	@Test("getOrganizations returns 304 Not Modified")
	func getOrganizations_304_response() async throws {

		// Given
		let eTag = "\"abc123\""
		stub(condition: isPath("/static/search/organizations.json")) { _ in
			HTTPStubsResponse(data: Data(), statusCode: 304, headers: nil)
		}
		let serverURL = try LocalizationServers.Server.testUrl()
		let sut = LocalizationAPIClient(serverURL)

		// When
		let result = try await sut.fetch(.organizations, eTag: eTag)

		// Then
		#expect(result.statusCode == 304)
		#expect(result.eTag == eTag)
		#expect(result.data == nil)
	}

	@Test("getOrganizations throws on undocumented status code")
	func getOrganizations_undocumented_response() async throws {

		// Given
		stub(condition: isPath("/static/search/organizations.json")) { _ in
			HTTPStubsResponse(data: Data(), statusCode: 500, headers: nil)
		}
		let serverURL = try LocalizationServers.Server.testUrl()
		let sut = LocalizationAPIClient(serverURL)

		// Then
		await #expect {
			// When
			_ = try await sut.fetch(.organizations, eTag: nil)
		} throws: { error in
			guard let error = error as? LocalizationAPIClientError else { return false }
			return error == .undocumented(500)
		}
	}

	// MARK: - getEndpoints

	@Test("getEndpoints returns 200 with data and ETag")
	func getEndpoints_200_response() async throws {

		// Given
		// Note: avoid URLs in stub values — NSJSONSerialization escapes forward slashes
		// by default, which causes byte-level inequality even though the JSON is semantically equal.
		let jsonData = Data("{\"key\":\"value\"}".utf8)
		stub(condition: isPath("/static/search/endpoints.json")) { _ in
			HTTPStubsResponse(
				data: jsonData,
				statusCode: 200,
				headers: [
					"ETag": "\"ep123\"",
					"Content-Type": "application/json"
				]
			)
		}
		let serverURL = try LocalizationServers.Server.testUrl()
		let sut = LocalizationAPIClient(serverURL)

		// When
		let result = try await sut.fetch(.endpoints, eTag: nil)

		// Then
		#expect(result.statusCode == 200)
		#expect(result.eTag == "\"ep123\"")
		#expect(result.data == jsonData)
	}

	@Test("getEndpoints returns 304 Not Modified")
	func getEndpoints_304_response() async throws {

		// Given
		let eTag = "\"ep123\""
		stub(condition: isPath("/static/search/endpoints.json")) { _ in
			HTTPStubsResponse(data: Data(), statusCode: 304, headers: nil)
		}
		let serverURL = try LocalizationServers.Server.testUrl()
		let sut = LocalizationAPIClient(serverURL)

		// When
		let result = try await sut.fetch(.endpoints, eTag: eTag)

		// Then
		#expect(result.statusCode == 304)
		#expect(result.eTag == eTag)
		#expect(result.data == nil)
	}

	@Test("getEndpoints throws on undocumented status code")
	func getEndpoints_undocumented_response() async throws {

		// Given
		stub(condition: isPath("/static/search/endpoints.json")) { _ in
			HTTPStubsResponse(data: Data(), statusCode: 429, headers: nil)
		}
		let serverURL = try LocalizationServers.Server.testUrl()
		let sut = LocalizationAPIClient(serverURL)

		// Then
		await #expect {
			// When
			_ = try await sut.fetch(.endpoints, eTag: nil)
		} throws: { error in
			guard let error = error as? LocalizationAPIClientError else { return false }
			return error == .undocumented(429)
		}
	}
}
