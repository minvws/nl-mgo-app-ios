/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension Error {
	
	/**
	Return a human-readable, localized string for error codes of the NSURLErrorDomain. Will simply return `localizedDescription` for if the
	receiver is not of that domain.
	
	The list of errors that are "humanized" is not necessarily exhaustive. All strings are returned `fhir_localized`.
	*/
	public var humanized: String {
		guard NSURLErrorDomain == _domain else {
			return localizedDescription
		}
		switch _code {
			case NSURLErrorBadURL:                return "The URL was malformed".fhirLocalized
			case NSURLErrorTimedOut:              return "The connection timed out".fhirLocalized
			case NSURLErrorUnsupportedURL:        return "The URL scheme is not supported".fhirLocalized
			case NSURLErrorCannotFindHost:        return "The host could not be found".fhirLocalized
			case NSURLErrorCannotConnectToHost:   return "A connection to the host cannot be established".fhirLocalized
			case NSURLErrorNetworkConnectionLost: return "The network connection was lost".fhirLocalized
			case NSURLErrorDNSLookupFailed:       return "The connection failed because the DNS lookup failed".fhirLocalized
			case NSURLErrorHTTPTooManyRedirects:  return "The HTTP connection failed due to too many redirects".fhirLocalized
			default:                              return localizedDescription
		}
	}
}
