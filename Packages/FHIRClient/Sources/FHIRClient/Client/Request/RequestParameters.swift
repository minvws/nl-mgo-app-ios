/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/**
Parameters to pass along when making a request.
*/
public struct RequestParameters {
	
	internal var parameters: [(RequestParameterField, String)]
	
	/** Designated initializer. */
	public init(_ params: [(RequestParameterField, String)]? = nil) {
		parameters = params ?? [(RequestParameterField, String)]()
	}
	
	/**
	Prepare a given mutable URL request with the receiver's parameters.
	*/
	public func prepare(request: inout URLRequest) {
		guard !parameters.isEmpty else {
			return
		}
		if let url = request.url, var comps = URLComponents(url: url, resolvingAgainstBaseURL: false) {
			var query = comps.queryItems ?? []
			for (param, value) in parameters {
				// Allow duplicate keys.
				query.append(URLQueryItem(name: param.rawValue, value: value))
			}
			comps.queryItems = query
			request.url = comps.url
		}
	}
}

/**
 Describe valid (and supported) FHIR request query parameters.
 */
public enum RequestParameterField: String {
	
	/// Category for ZIB
	case category = "category"
	
	/// class
	case classParam = "class"
	
	/// code
	case code = "code"
	
	/// date
	case date = "date"
	
	/// format
	case format = "_format"
	
	/// Include the field
	case include = "_include"
	
	/// Period of use
	case periodOfUse = "periodofuse"
	
	/// status
	case status = "status"
	
	/// type
	case type = "type"
	
}
