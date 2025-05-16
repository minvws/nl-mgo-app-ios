/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/**
Base implementation of `RequestHandler`.
*/
open class RequestHandlerImpl: RequestHandler {
	
	/// The HTTP method of the request.
	public let method: RequestMethod
	
	/// Headers to be used on the request.
	open var headers = RequestHeaders()
	
	/// Request parameters to pass along.
	open var parameters = RequestParameters()
	
	/// The data to be used in the request body.
	open var data: Data?
	
	/**
	Designated initializer.
	*/
	public required init(_ method: RequestMethod) {
		self.method = method
	}
	
	// MARK: - Preparation
	
	/**
	Add the given headers to the request, overwriting existing headers.
	
	- parameter headers: The headers to add to the receiver
	*/
	open func add(headers inHeaders: RequestHeaders) {
		var hdrs = headers
		inHeaders.headers.forEach { hdrs[$0] = $1 }
		headers = hdrs
	}
	
	/**
	Give the request type a chance to prepare/alter the URL request.
	
	Typically the FHIRRequestMethod instance sets the correct HTTPMethod as well as correct FHIR headers. It will also inspect the `options`
	property and add appropriate query params.
	*/
	open func prepare(request: inout URLRequest) throws {
		let params = parameters
		
		method.prepare(request: &request, body: data)
		headers.prepare(request: &request)
		params.prepare(request: &request)
	}
	
	// MARK: - Response
	
	/**
	Instantiate a FHIRServerResponse based on the response and data that we get.
	*/
	open func response(response: URLResponse?, data inData: Data? = nil, error: Error? = nil) -> ServerResponse {
		if let res = response {
			return DataResponse(handler: self, response: res, data: inData, error: error)
		}
		if let error = error {
			return DataResponse(error: error, handler: self)
		}
		return DataResponse(error: FHIRError.noResponseReceived, handler: self)
	}
	
	/**
	Convenience method to indicate a request that has not actually been sent.
	*/
	open func notSent(_ reason: String) -> ServerResponse {
		return DataResponse(error: FHIRError.requestNotSent(reason), handler: self)
	}
}
