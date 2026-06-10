/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import Testing
@testable import FHIRClient

@Suite struct RequestParametersTests {

	private let baseURL = URL(string: "https://example.com/fhir")!

	@Test("Empty parameters leave the request URL unchanged")
	func emptyParameters_noOpOnURL() {

		// Given
		let params = RequestParameters()
		var request = URLRequest(url: baseURL)

		// When
		params.prepare(request: &request)

		// Then
		#expect(request.url == baseURL)
	}

	@Test("Single parameter is appended as a query item")
	func singleParameter_appendsQueryItem() throws {

		// Given
		let params = RequestParameters([(.status, "active")])
		var request = URLRequest(url: baseURL)

		// When
		params.prepare(request: &request)

		// Then
		let url = try #require(request.url)
		let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
		let items = try #require(components.queryItems)
		#expect(items.count == 1)
		#expect(items[0].name == "status")
		#expect(items[0].value == "active")
	}

	@Test("Multiple parameters are all appended")
	func multipleParameters_allAppended() throws {

		// Given
		let params = RequestParameters([(.status, "active"), (.category, "foo")])
		var request = URLRequest(url: baseURL)

		// When
		params.prepare(request: &request)

		// Then
		let url = try #require(request.url)
		let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
		let items = try #require(components.queryItems)
		#expect(items.count == 2)
	}

	@Test("Duplicate keys are allowed and both values are preserved")
	func duplicateKeys_bothAppended() throws {

		// Given
		let params = RequestParameters([(.status, "active"), (.status, "inactive")])
		var request = URLRequest(url: baseURL)

		// When
		params.prepare(request: &request)

		// Then
		let url = try #require(request.url)
		let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
		let items = try #require(components.queryItems)
		#expect(items.count == 2)
		#expect(items.filter { $0.name == "status" }.count == 2)
	}

	@Test("Parameters are appended to an existing query string without overwriting it")
	func existingQueryString_parametersAppended() throws {

		// Given
		let baseWithQuery = try #require(URL(string: "https://example.com/fhir?_format=json"))
		let params = RequestParameters([(.status, "active")])
		var request = URLRequest(url: baseWithQuery)

		// When
		params.prepare(request: &request)

		// Then
		let url = try #require(request.url)
		let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
		let items = try #require(components.queryItems)
		#expect(items.count == 2)
		#expect(items.contains { $0.name == "_format" && $0.value == "json" })
		#expect(items.contains { $0.name == "status" && $0.value == "active" })
	}

	@Test("Parameter values with special characters are round-tripped correctly")
	func specialCharacters_roundTrippedCorrectly() throws {

		// Given
		let params = RequestParameters([(.category, "urn:oid:2.16.840.1.113883|6")])
		var request = URLRequest(url: baseURL)

		// When
		params.prepare(request: &request)

		// Then
		let url = try #require(request.url)
		let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
		let items = try #require(components.queryItems)
		#expect(items.first?.value == "urn:oid:2.16.840.1.113883|6")
	}
}
