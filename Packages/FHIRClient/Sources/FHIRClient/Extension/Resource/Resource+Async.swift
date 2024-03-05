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
	 
	 - parameter id:       The id of the resource to read
	 - parameter client:   The server from which to read
	 - parameter options:  Options to use when executing this request, if any
	 - parameter callback: The callback to execute once done. The callback is NOT guaranteed to be executed on the main thread!
	 */
	class func read(_ id: String, client: FHIRClient, options: RequestOption = []) async throws -> Resource {
		let path = "\(resourceType.rawValue)/\(id)"
		return try await readFrom(path, client: client, options: options)
	}
	
	/**
	 Reads the resource from the given path on the given server.
	 This is the async version
	 
	 This method creates a FHIRJSONRequestHandler for a GET request and deserializes the returned JSON into an instance on success.
	 
	 - parameter path:     The relative path on the server from which to read resource data from
	 - parameter client:   The server to use
	 - parameter options:  Options to use when executing this request, if any
	 - Returns: the requested resource
	 */
	class func readFrom(_ path: String, client: FHIRClient, options: RequestOption = []) async throws -> Resource {
		guard var handler = client.handlerForRequest(withMethod: .GET, resource: nil) else {
			throw FHIRError.noRequestHandlerAvailable(.GET)
		}
		handler.options = options
		let response = await client.performRequest(against: path, handler: handler)
		
		if let error = response.error {
			throw error
		} else {
			do {
				let resource = try response.responseResource(ofType: Resource.self)
				
				try response.applyHeaders(to: resource)
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
