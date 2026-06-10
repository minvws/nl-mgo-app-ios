/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import HTTPTypes

/**
 Encapsulates a server response, which can also indicate that there was no response or not even a request, in which case the `error`
 property carries the only useful information.
 */
open class DataResponse {
	
	/// The HTTP status code.
	public let status: Int
	
	/// Response headers.
	public let headers: HTTPFields
	
	/// The response body data.
	open var body: Data?
	
	/// The error encountered, if any.
	open var error: FHIRError?
	
	/**
	 Instantiate a response from a completed HTTP request.
	 
	 - parameter response: The `HTTPResponse` received from the server.
	 - parameter data:     The response body data, if any.
	 - parameter error:    The error reported by the URL session, if any.
	 */
	public required init(
		response: HTTPResponse,
		data: Data?,
		error: Error?
	) {
		self.body = data
		self.status = response.status.code
		self.headers = response.headerFields
		
		if let error, NSURLErrorDomain == error._domain {
			self.error = FHIRError.requestError(self.status, error.humanized)
		} else if let error = error as? FHIRError {
			self.error = error
		} else if let error {
			self.error = FHIRError.error(error.localizedDescription)
		}
	}
	
	/**
	 Instantiate an error-only response when no HTTP response was received.
	 
	 - parameter error: The error that prevented a response from being received.
	 */
	public required init(error: Error) {
		self.status = 0
		self.headers = HTTPFields()
		if NSURLErrorDomain == error._domain {
			self.error = FHIRError.requestError(status, error.humanized)
		} else if let error = error as? FHIRError {
			self.error = error
		} else {
			self.error = FHIRError.error("\(error)")
		}
	}
}
