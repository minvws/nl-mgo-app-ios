/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/**
FHIR errors.
*/
public enum FHIRError: Error, CustomStringConvertible {
	case error(String)
	case requestNotSent(String)
	case requestError(Int, String)
	case noResponseReceived
	case responseNoResourceReceived
	
	// MARK: - CustomStringConvertible
	
	public var description: String {
		switch self {
			case .error(let message):
				return message
			case .requestNotSent(let reason):
				return "\("Request not sent".fhirLocalized): \(reason)"
			case .requestError(let status, let message):
				return "\("Error".fhirLocalized) \(status): \(message)"
			case .noResponseReceived:
				return "No response received".fhirLocalized
			case .responseNoResourceReceived:
				return "No resource data was received with the response".fhirLocalized
		}
	}
}

extension Error {
	
	/**
	Converts any `Error` into `FHIRError`; returns self if the receiver is a FHIRError already.
	*/
	public var asFHIRError: FHIRError {
		if let ferr = self as? FHIRError {
			return ferr
		}
		return FHIRError.error("\(localizedDescription)")
	}
}

extension String {
	/**
	Convenience getter using `NSLocalizedString()` with no comment.
	
	*/
	public var fhirLocalized: String {
		return NSLocalizedString(self, comment: "")
	}
}
