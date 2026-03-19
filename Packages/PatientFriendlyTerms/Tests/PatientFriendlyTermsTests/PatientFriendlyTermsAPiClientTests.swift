/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
@testable import PatientFriendlyTerms
import OHHTTPStubs
import OHHTTPStubsSwift

class PatientFriendlyTermsAPIClientTests {
	
	deinit {
		HTTPStubs.removeAllStubs()
	}
	
	@Test("Test the client with a 200 response")
	func client_200_response() async throws {
		
		// Given
		stub(condition: isPath("/v1/mgo/pft.json")) { _ in
			return HTTPStubsResponse(
				jsonObject: [
					"123":
						[
							"name": "name",
							"synonym": "synonym",
							"description": "description"
						]
				],
				statusCode: 200,
				headers: [
					"ETag": "\"123456\""
				]
			)
		}
		let serverUrl = try PatientFriendlyTermsServers.Server1.url()
		let sut = PatientFriendlyTermsAPIClient(serverUrl)
		
		// When
		let result = try await sut.fetchTerms(eTag: nil)
		
		// Then
		#expect(result.statusCode == 200)
		#expect(result.eTag == "\"123456\"")
		#expect(result.terms?.additionalProperties.count == 1)
		#expect(result.terms?.additionalProperties["123"]?.name == "name")
		#expect(result.terms?.additionalProperties["123"]?.synonym == "synonym")
		#expect(result.terms?.additionalProperties["123"]?.description == "description")
	}
	
	@Test("Test the client with basic authentication with a 200 response")
	func client_withBasicAuthentication_200_response() async throws {
		
		// Given
		stub(condition: isPath("/v1/mgo/pft.json")) { _ in
			return HTTPStubsResponse(
				jsonObject: [
					"123":
						[
							"name": "name",
							"synonym": "synonym",
							"description": "description"
						]
				],
				statusCode: 200,
				headers: [
					"ETag": "\"123456\""
				]
			)
		}
		let serverUrl = try PatientFriendlyTermsServers.Server1.url()
		let sut = PatientFriendlyTermsAPIClient(
			serverUrl,
			username: "test",
			password: "test"
		)
		
		// When
		let result = try await sut.fetchTerms(eTag: nil)
		
		// Then
		#expect(result.statusCode == 200)
		#expect(result.eTag == "\"123456\"")
		#expect(result.terms?.additionalProperties.count == 1)
		#expect(result.terms?.additionalProperties["123"]?.name == "name")
		#expect(result.terms?.additionalProperties["123"]?.synonym == "synonym")
		#expect(result.terms?.additionalProperties["123"]?.description == "description")
	}
	
	@Test("Test the client with a 304 response")
	func client_304_response() async throws {
		
		// Given
		let eTag = "\"123456\""
		stub(condition: isPath("/v1/mgo/pft.json")) { _ in
			return HTTPStubsResponse(
				data: Data(),
				statusCode: 304,
				headers: [
					"ETag": eTag
				]
			)
		}
		let serverUrl = try PatientFriendlyTermsServers.Server1.url()
		let sut = PatientFriendlyTermsAPIClient(serverUrl)
		
		// When
		let result = try await sut.fetchTerms(eTag: eTag)
		
		// Then
		#expect(result.statusCode == 304)
		#expect(result.eTag == eTag)
		#expect(result.terms == nil)
	}
	
	@Test("Test the client with an undocumented response")
	func client_undocumented_response() async throws {
		
		// Given
		let eTag = "\"123456\""
		stub(condition: isPath("/v1/mgo/pft.json")) { _ in
			return HTTPStubsResponse(
				data: Data(),
				statusCode: 429,
				headers: nil
			)
		}
		let serverUrl = try PatientFriendlyTermsServers.Server1.url()
		let sut = PatientFriendlyTermsAPIClient(serverUrl)
		
		// Then
		await #expect {
			// When
			_ = try await sut.fetchTerms(eTag: eTag)
		} throws: { error in
			guard let error = error as? PatientFriendlyTermsAPIClientError else {
				return false
			}
			return error == PatientFriendlyTermsAPIClientError.undocumented(429)
		}
	}
}
