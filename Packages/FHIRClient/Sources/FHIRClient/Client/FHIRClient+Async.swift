/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension FHIRClient {
	
	/**
	 Reads the resource from the given path on the given server as Data.
	 This is the async version
	 
	 This method creates a FHIRJSONRequestHandler for a GET request and returns the data.
	 Parsing of the response into FHIR Resources will be done by the Parser in a separate step.
	 
	 - parameter path:      The relative path on the server from which to read resource data from
	 - parameter parameters  The request parameters to add
	 - parameter headers:   Headers to send to the server
	 - Returns: the requested data
	 */
	public func readDataFrom(_ path: String, parameters: RequestParameters = RequestParameters(), headers: RequestHeaders?) async throws -> Data {
		var handler = self.handlerForRequest(withMethod: .GET)
		handler.parameters = parameters
		if let headers {
			handler.add(headers: headers)
		}
		let response = await self.performRequest(against: path, handler: handler)
		
		if let error = response.error {
			throw error
		} else {
			guard let body = response.body else {
				throw FHIRError.responseNoResourceReceived
			}
			return body
		}
	}
}
