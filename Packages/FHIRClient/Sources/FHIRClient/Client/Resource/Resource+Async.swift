/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public extension Resource {
	
	/**
	 Reads the resource from the given path on the given server.
	 This is the async version
	 
	 This method creates a FHIRJSONRequestHandler for a GET request and deserializes the returned JSON into an instance on success.
	 
	 - parameter path:      The relative path on the server from which to read resource data from
	 - parameter client:    The server to use
	 - parameter parameters  The request parameters to add
	 - parameter options:   Options to use when executing this request, if any
	 - parameter headers:   Headers to send to the server
	 - Returns: the requested resource
	 */
	class func readFrom(_ path: String, client: FHIRClient, parameters: RequestParameters = RequestParameters(), options: RequestOption = [], headers: RequestHeaders?) async throws -> Resource {
		guard var handler = client.handlerForRequest(withMethod: .GET, resource: nil) else {
			throw FHIRError.noRequestHandlerAvailable(.GET)
		}
		handler.options = options
		handler.parameters = parameters
		if let headers {
			handler.add(headers: headers)
		}
		let response = await client.performRequest(against: path, handler: handler)
		
		if let error = response.error {
			throw error
		} else {
			do {
				let resource = try response.responseResource(ofType: Resource.self)
				
				try response.applyHeaders(to: resource, baseURL: client.baseURL)
				if nil == resource.id, let lpc = URL(string: path) {
					resource.id = lpc.lastPathComponent.asFHIRStringPrimitive()
				}
				return resource
			} catch {
				throw error.asFHIRError
			}
		}
	}
}
