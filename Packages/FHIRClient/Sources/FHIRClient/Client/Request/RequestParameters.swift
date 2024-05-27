/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/**
Parameters to pass along when making a request.
*/
public struct RequestParameters {
	
	private var parameters: [RequestParameterField: String]
	
	/** Designated initializer. */
	public init(_ params: [RequestParameterField: String]? = nil) {
		parameters = params ?? [RequestParameterField: String]()
	}
	
	public subscript(key: RequestParameterField) -> String? {
		get { return parameters[key] }
		set { parameters[key] = newValue }
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
				query = query.filter { param.rawValue != $0.name }
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
	
	/// Request a summary; you probably want `Summary.true.rawValue` as its value.
	case summary = "_summary"
	
	/// Include only the listed top-level elements; provide a comma-separated list of element names as value.
	case elements = "_elements"
	
	/// Category for ZIB
	case category = "category"
	
	/// Include the field
	case include = "_include"
	
	/**
	The options that are valid for the `summary` case.
	*/
	public enum Summary: String {
		case `true`  = "true"
		case `false` = "false"
		case text    = "text"
		case data    = "data"
		case count   = "count"
	}
}
