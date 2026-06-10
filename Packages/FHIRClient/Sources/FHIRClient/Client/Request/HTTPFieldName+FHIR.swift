/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import HTTPTypes

fileprivate extension HTTPField.Name {
	
	/// Creates an `HTTPField.Name` from a string known to be a valid HTTP token,
	/// trapping on invalid input.
	init(fhir name: String) {
		
		guard let value = Self(name) else {
			preconditionFailure("'\(name)' is not a valid HTTP field name")
		}
		self = value
	}
}

/// FHIR- and MGO-specific HTTP header field names that are not part of the
/// `swift-http-types` standard set.
public extension HTTPField.Name {
	
	/// The `Accept-Charset` header. Not part of the swift-http-types standard set
	/// (the header is largely deprecated in modern HTTP), but FHIR clients seed it
	/// with `utf-8` as a defensive default.
	static let acceptCharset = Self(fhir: "Accept-Charset")
	
	/// MGO-specific header identifying the DVA target endpoint.
	static let dvaTarget = Self(fhir: "X-MGO-DVA-TARGET")
	
	/// MGO-specific header identifying the medmij provider.
	static let medmijId = Self(fhir: "X-MGO-HEALTHCARE-MEDMIJ-ID")
	
	/// MGO-specific header identifying the data service.
	static let dataServiceId = Self(fhir: "X-MGO-DATASERVICE-ID")
}
