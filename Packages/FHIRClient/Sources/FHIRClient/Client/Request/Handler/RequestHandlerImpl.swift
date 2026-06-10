/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import HTTPTypes

open class RequestHandlerImpl {
	
	/// The HTTP method of the request.
	public let method: HTTPRequest.Method
	
	/// Headers to be used on the request. Seeded with the FHIR default `Accept-Charset: utf-8`.
	open var headers: HTTPFields = [.acceptCharset: "utf-8"]
	
	/// Request parameters to pass along.
	open var parameters = RequestParameters()
	
	/// The data to be used in the request body.
	open var data: Data?
	
	/**
	 Designated initializer.
	 */
	public init(_ method: HTTPRequest.Method) {
		self.method = method
	}
	
	// MARK: - Preparation
	
	/**
	 Merge the given headers into the receiver, overwriting any existing values for the same field names.
	 
	 - parameter headers: The headers to add
	 */
	open func add(headers newHeaders: HTTPFields) {
		for field in newHeaders {
			headers[field.name] = field.value
		}
	}
	
	/**
	 Give the receiver a chance to prepare/alter the URL request (set method, headers, query params, body).
	 */
	open func prepare(request: inout URLRequest) throws {
		request.httpMethod = method.rawValue
		for field in headers {
			request.setValue(field.value, forHTTPHeaderField: field.name.rawName)
		}
		if data != nil, method != .get, method != .delete, method != .options {
			request.httpBody = data
		}
		parameters.prepare(request: &request)
	}
	
	// MARK: - Response
	
	/**
	 Instantiate a `DataResponse` from the typed HTTP response and body bytes.
	 
	 - parameter response: The `HTTPResponse` resulting from the request, if any
	 - parameter data:     The body data that was returned, if any
	 - parameter error:    The error that was reported, if any
	 */
	open func response(
		response: HTTPResponse? = nil,
		data inData: Data? = nil,
		error: Error? = nil
	) -> DataResponse {

		if let response {
			return DataResponse(
				response: response,
				data: inData,
				error: error
			)
		}
		if let error {
			return DataResponse(error: error)
		}
		return DataResponse(error: FHIRError.noResponseReceived)
	}

	/**
	 Convenience method to indicate a request that has not actually been sent.
	 */
	open func notSent(_ reason: String) -> DataResponse {
		return DataResponse(error: FHIRError.requestNotSent(reason))
	}
}
