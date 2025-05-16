/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/**
Struct to describe REST request types, with a convenience method to make a request FHIR compliant.
*/
public enum RequestMethod: String {
	case GET
	case PUT
	case POST
	case PATCH
	case DELETE
	case OPTIONS
	
	/**
	Prepare a given mutable URL request with the respective method and body values.
	*/
	public func prepare(request: inout URLRequest, body: Data? = nil) {
		request.httpMethod = rawValue
		
		switch self {
			case .GET:
				break
			case .PUT:
				request.httpBody = body
			case .POST:
				request.httpBody = body
			case .PATCH:
				request.httpBody = body
			case .DELETE:
				break
			case .OPTIONS:
				break
		}
	}
}
