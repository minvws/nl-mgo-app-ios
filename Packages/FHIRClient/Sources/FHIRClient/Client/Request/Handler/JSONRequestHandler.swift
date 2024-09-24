/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/**
Prepare and handle a request returning JSON data.

JSON body data can be greated from the resource, if the receiver holds on to one. The header's content type for PUT and POST will be set to
"application/fhir+json; charset=utf-8" no matter what.
*/
open class JSONRequestHandler: RequestHandlerImpl {
	
	override open func prepare(request: inout URLRequest) throws {
		
		if let username = ProcessInfo.processInfo.environment["MGO_BASIC_AUTH_USERNAME"],
		   let password = ProcessInfo.processInfo.environment["MGO_BASIC_AUTH_PASSWORD"] {
			let loginString = String(format: "%@:%@", username, password)
			if let loginData = loginString.data(using: String.Encoding.utf8) {
				let base64LoginString = loginData.base64EncodedString()
				headers[.authorization] = "Basic \(base64LoginString)"
			}
		}
		
		headers[.accept] = "application/fhir+json"
		switch method {
			case .PUT:
				headers[.contentType] = "application/fhir+json; charset=utf-8"
			case .POST:
				headers[.contentType] = "application/fhir+json; charset=utf-8"
			default:
				break
		}
		try super.prepare(request: &request)
	}
	
	/**
	Instantiate a FHIRServerResponse based on the response and data that we get.
	*/
	override open func response(response: URLResponse?, data inData: Data? = nil, error: Error? = nil) -> ServerResponse {
		if let res = response {
			return JSONResponse(handler: self, response: res, data: inData, error: error)
		}
		if let error = error {
			return JSONResponse(error: error, handler: self)
		}
		return JSONResponse(error: FHIRError.noResponseReceived, handler: self)
	}
}
