/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
	
	/// The error encountered, if any.
	open var error: FHIRError?
	
	/**
	Instantiate a FHIRServerResponse from a (HTTP)URLResponse, Data and an optional Error.
	*/
	public required init(handler: RequestHandler, response: URLResponse, data: Data?, error: Error?) {
		
		self.handler = handler
		self.body = data
		
		var localStatus = 0
		var localHeaders = [String: String]()
		
		// parse status and headers from the URL response
		(response as? HTTPURLResponse).map { response in
			localStatus = response.statusCode
			response.allHeaderFields.forEach { (key: AnyHashable, value: Any) in
				if var keyStr = key as? String, let valStr = value as? String {
					keyStr = keyStr.replacingOccurrences(of: "Etag", with: "ETag")
					localHeaders[keyStr] = valStr
				}
			}
		}
		
		// was there an error?
		if let error = error, NSURLErrorDomain == error._domain {
			self.error = FHIRError.requestError(localStatus, error.humanized)
		} else if let error = error as? FHIRError {
			self.error = error
		} else if let error = error {
			self.error = FHIRError.error(error.localizedDescription)
		}
		
		self.status = localStatus
		self.headers = localHeaders
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
}
