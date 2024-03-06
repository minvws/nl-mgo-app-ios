/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/**
Encapsulates a server response with JSON response body, if any.
*/
open class JSONResponse: DataResponse {
	
	/**
	If the status is >= 400, the response body is checked for an OperationOutcome and its first issue item is turned into an error message.
	*/
	public required init(handler: RequestHandler, response: URLResponse, data inData: Data?, error: Error?) {
		super.init(handler: handler, response: response, data: inData, error: error)
		
		// fill error on HTTP status >= 400
		if status >= 400 {
			do {
				self.outcome = try responseResource(ofType: OperationOutcome.self)
			} catch {  }
			
			if let erritem = self.outcome?.issue.first {
				let errstr = "[\(erritem.severity.value?.rawValue ?? "unknown")] \(erritem.diagnostics ?? "unknown")"
				self.error = FHIRError.requestError(status, errstr)
			} else {
				var errstr = "Error"
				if let urlResponse = response as? HTTPURLResponse {
					errstr = HTTPURLResponse.localizedString(forStatusCode: urlResponse.statusCode)
				}
				self.error = FHIRError.requestError(status, errstr)
			}
		}
	}
	
	public required init(error: Error, handler: RequestHandler? = nil) {
		super.init(error: error, handler: handler)
	}
	
	/**
	Uses FHIRElement's factory method to instantiate the resource of the given type from the response.
	
	- parameter ofType: The type of resource to extract
	- returns:          The resource that was found in the response if it is of the desired type
	- throws:           Errors if there was no response, if it was of a different type or if there were errors in the data
	*/
	override open func responseResource<T: Resource>(ofType: T.Type) throws -> T {
		guard let body = body else {
			throw FHIRError.responseNoResourceReceived
		}
		
		let decoder = JSONDecoder()
		do {
			let proxy = try decoder.decode(ResourceProxy.self, from: body)
			
			if let resource = proxy.get(if: T.self) {
				return resource
			}
		} catch {
			if let decodingError = error as? DecodingError {
				switch decodingError {
					case .typeMismatch(_, let context):
						throw FHIRError.jsonParsingError("typeMismatch", context.debugDescription)
					case .valueNotFound(_, let context):
						throw FHIRError.jsonParsingError("valueNotFound", context.debugDescription)
					case .keyNotFound(let codingKey, let context):
						throw FHIRError.jsonParsingError(codingKey.stringValue, context.debugDescription)
					case .dataCorrupted(let context):
						throw FHIRError.jsonParsingError("dataCorropted", context.debugDescription)
					@unknown default:
						throw FHIRError.jsonParsingError("unknown source", "")
				}
			}
		}
		throw FHIRError.responseNoResourceReceived
	}
}
