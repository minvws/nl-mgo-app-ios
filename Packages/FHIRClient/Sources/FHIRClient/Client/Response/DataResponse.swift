/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/**
Encapsulates a server response, which can also indicate that there was no response or not even a request, in which case the `error`
property carries the only useful information.
*/
open class DataResponse: ServerResponse {
	
	/// The handler handling the request provoking this response.
	public internal(set) var handler: RequestHandler?
	
	/// The HTTP status code.
	public let status: Int
	
	/// Response headers.
	public let headers: [String: String]
	
	/// The response body data.
	open var body: Data?
	
	/// The request's operation outcome, if any.
	public internal(set) var outcome: OperationOutcome?
	
	/// The error encountered, if any.
	open var error: FHIRError?
	
	/**
	Instantiate a FHIRServerResponse from a (HTTP)URLResponse, Data and an optional Error.
	*/
	public required init(handler: RequestHandler, response: URLResponse, data: Data?, error: Error?) {
		var status = 0
		var headers = [String: String]()
		
		// parse status and headers from the URL response
		if let http = response as? HTTPURLResponse {
			status = http.statusCode
			for (key, val) in http.allHeaderFields {
				if let keystr = key as? String {
					if let valstr = val as? String {
						headers[("Etag" == keystr) ? "ETag" : keystr] = valstr		// NSHTTPURLResponse returns "Etag"
					} else {
						print("Not a string in headers: \(val) (for \(keystr))") // swiftlint:disable:this disable_print
					}
				}
			}
		}
		
		// was there an error?
		if let error = error, NSURLErrorDomain == error._domain {
			self.error = FHIRError.requestError(status, error.humanized)
		} else if let error = error as? FHIRError {
			self.error = error
		} else if let error = error {
			self.error = FHIRError.error(error.localizedDescription)
		}
		
		self.handler = handler
		self.status = status
		self.headers = headers
		self.body = data
	}
	
	public required init(error: Error, handler: RequestHandler? = nil) {
		self.handler = handler
		self.status = 0
		self.headers = [String: String]()
		if NSURLErrorDomain == error._domain {
			self.error = FHIRError.requestError(status, error.humanized)
		} else if let error = error as? FHIRError {
			self.error = error
		} else {
			self.error = FHIRError.error("\(error)")
		}
	}
	
	// MARK: - Responses
	
	/**
	The base method does not know how to extract a response resource, so this will throw `FHIRError.responseNoResourceReceived`.
	
	- parameter type: The response resource's type
	- returns: An instance of the expected type
	*/
	open func responseResource<T: Resource>(ofType: T.Type) throws -> T {
		throw FHIRError.responseNoResourceReceived
	}
}
