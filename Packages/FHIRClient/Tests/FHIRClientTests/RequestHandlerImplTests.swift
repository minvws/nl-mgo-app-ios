/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import HTTPTypes
import Testing
@testable import FHIRClient

@Suite struct RequestHandlerImplTests {

	// MARK: - notSent(_:)

	@Test("notSent returns a DataResponse with a .requestNotSent error")
	func notSent_returnsDataResponseWithRequestNotSentError() throws {

		// Given
		let handler = RequestHandlerImpl(.get)
		let reason = "Missing authentication token"

		// When
		let dataResponse = try #require(handler.notSent(reason))

		// Then
		guard case .requestNotSent(let message) = dataResponse.error else {
			Issue.record("Expected .requestNotSent, got \(String(describing: dataResponse.error))")
			return
		}
		#expect(message == reason)
		#expect(dataResponse.status == 0)
	}

	// MARK: - prepare(_:)

	@Test("prepare sets the HTTP method on the request")
	func prepare_setsHTTPMethod() throws {
		let handler = RequestHandlerImpl(.post)
		var request = URLRequest(url: URL(string: "https://example.com")!)
		try handler.prepare(request: &request)
		#expect(request.httpMethod == "POST")
	}

	@Test("prepare sets custom request headers")
	func prepare_setsRequestHeaders() throws {
		let handler = RequestHandlerImpl(.get)
		handler.headers[.dvaTarget] = "test-target"
		var request = URLRequest(url: URL(string: "https://example.com")!)
		try handler.prepare(request: &request)
		#expect(request.value(forHTTPHeaderField: "X-MGO-DVA-TARGET") == "test-target")
	}

	@Test("prepare attaches body data for POST")
	func prepare_attachesBodyDataForPost() throws {
		let handler = RequestHandlerImpl(.post)
		handler.data = Data("body".utf8)
		var request = URLRequest(url: URL(string: "https://example.com")!)
		try handler.prepare(request: &request)
		#expect(request.httpBody == Data("body".utf8))
	}

	@Test("prepare does not attach body data for GET")
	func prepare_doesNotAttachBodyDataForGet() throws {
		let handler = RequestHandlerImpl(.get)
		handler.data = Data("body".utf8)
		var request = URLRequest(url: URL(string: "https://example.com")!)
		try handler.prepare(request: &request)
		#expect(request.httpBody == nil)
	}

	@Test("prepare does not attach body data for DELETE")
	func prepare_doesNotAttachBodyDataForDelete() throws {
		let handler = RequestHandlerImpl(.delete)
		handler.data = Data("body".utf8)
		var request = URLRequest(url: URL(string: "https://example.com")!)
		try handler.prepare(request: &request)
		#expect(request.httpBody == nil)
	}

	@Test("prepare does not attach body data for OPTIONS")
	func prepare_doesNotAttachBodyDataForOptions() throws {
		let handler = RequestHandlerImpl(.options)
		handler.data = Data("body".utf8)
		var request = URLRequest(url: URL(string: "https://example.com")!)
		try handler.prepare(request: &request)
		#expect(request.httpBody == nil)
	}

	// MARK: - response(_:data:error:)

	@Test("response with HTTPResponse and data returns a populated DataResponse")
	func response_withHTTPResponseAndData_returnsPopulatedResponse() {
		let handler = RequestHandlerImpl(.get)
		let httpResponse = HTTPResponse(status: .ok)
		let data = Data("body".utf8)

		let response = handler.response(response: httpResponse, data: data, error: nil)

		#expect(response.status == 200)
		#expect(response.body == data)
		#expect(response.error == nil)
	}

	@Test("response with nil HTTPResponse and an error returns an error DataResponse")
	func response_withNilHTTPResponseAndError_returnsErrorResponse() {
		let handler = RequestHandlerImpl(.get)
		let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut)

		let response = handler.response(response: nil, data: nil, error: error)

		#expect(response.status == 0)
		guard case .requestError = response.error else {
			Issue.record("Expected .requestError, got \(String(describing: response.error))")
			return
		}
	}

	@Test("response with nil HTTPResponse and no error returns a .noResponseReceived error")
	func response_withNilHTTPResponseAndNoError_returnsNoResponseReceived() {
		let handler = RequestHandlerImpl(.get)

		let response = handler.response(response: nil, data: nil, error: nil)

		guard case .noResponseReceived = response.error else {
			Issue.record("Expected .noResponseReceived, got \(String(describing: response.error))")
			return
		}
	}
}
