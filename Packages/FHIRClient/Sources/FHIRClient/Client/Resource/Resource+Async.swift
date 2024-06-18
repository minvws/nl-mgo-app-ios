/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public extension Resource {
	
	/**
	 Reads the resource with the given id from the given server.
	 This is the async version
	 
	 Forwards to class method `readFrom` with the resource's relative URL, created from the supplied id and the resource's base.
	 
	 - parameter id:        The id of the resource to read
	 - parameter client:    The server from which to read
	 - parameter parameters  The request parameters to add
	 - parameter options:   Options to use when executing this request, if any
	 - parameter dvaTarget: What target should we add to the headers
	 */
	class func read(_ id: String?, client: FHIRClient, parameters: RequestParameters = RequestParameters(), options: RequestOption = [], dvaTarget: String?) async throws -> Resource {
		var path = "\(resourceType.rawValue)"
		if let id {
			path += "/\(id)"
		}
		var headers: RequestHeaders?
		if let dvaTarget {
			headers = RequestHeaders([RequestHeaderField.dvaTarget: dvaTarget])
		}
		
		return try await readFrom(path, client: client, parameters: parameters, options: options, headers: headers)
	}
	
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
