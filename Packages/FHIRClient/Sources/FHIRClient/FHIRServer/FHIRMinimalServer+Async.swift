/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIR

public extension FHIRMinimalServer {
	
	/**
	 Method to execute a request against a given relative URL with a given request/response handler.
	 This is the async version
	 
	 - parameter path:     The path, relative to the server's base; may include URL query and URL fragment (!)
	 - parameter handler:  The FHIRRequestHandler that prepares the request and processes the response
	 - Returns:  the server response
	 */
	
	func performRequest(against path: String, handler: FHIRRequestHandler) async -> FHIRServerResponse {
		
		guard let url = absoluteURL(for: path, handler: handler) else {
			return handler.notSent("Failed to parse path «\(path)» relative to server base URL")
		}
		return await performRequest(on: url, handler: handler)
	}
	
	/**
	 Method to execute a request against a given absolute URL with a given request/response handler. 
	 This is the async version
	 
	 This method will use the request handler to prepare the request (i.e. add headers and prepare body data), then hand it over to
	 `perform(request:completionHandler:)` to actually perform the request. Finally, the response data/URLResponse/error is handed to the
	 request handler and converted into the `FHIRServerResponse` that is delivered to you in the callback.
	 
	 - parameter url:      The full URL; may include query parts and fragment (!)
	 - parameter handler:  The FHIRRequestHandler that prepares the request and processes the response
	 - Returns: the server response
	 */
	
	func performRequest(on url: URL, handler: FHIRRequestHandler) async -> FHIRServerResponse {
		
		var request = configurableRequest(for: url)
		do {
			try handler.prepare(request: &request)
			let (data, response1, error) = await perform(request: request)
			return handler.response(response: response1, data: data, error: error)
		} catch let error {
			return handler.notSent("Failed to prepare request against \(url): \(error)")
		}
	}
	
	/**
	 This is the last method in the chain to actually perform a request. Uses `URLSession().dataTask(with:completionHandler:)`.
	 This is the async wrapper
	 
	 - parameter request:           The URL request to perform as-is
	 - returns:                     returning optional data, response and error instances, when all has completed
	 */
	func perform(request: URLRequest) async -> (Data?, URLResponse?, Error?) {
		
		await withCheckedContinuation { continuation in
			_ = perform(request: request) { data, response, error in
				continuation.resume(returning: (data, response, error))
			}
		}
	}
}
