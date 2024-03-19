/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/**
FHIR errors.
*/
public enum FHIRError: Error, CustomStringConvertible {
	case error(String)
	
	case resourceLocationUnknown
	case resourceWithoutServer
	case resourceWithoutId
	case resourceAlreadyHasId
	
	/// The resource at path (1st string) could not be instantiated because of error (2nd string).
	case resourceFailedToInstantiate(String, String)
	
	/// The resource failed validation
	case resourceFailedToValidate(FHIRValidationError)
	case resourceCannotContainItself
	
	case requestCannotPrepareBody
	case requestNotSent(String)
	case requestError(Int, String)
	case noRequestHandlerAvailable(RequestMethod)
	case noResponseReceived
	
	/// The "Location" response (1st string) specifies a different type than exected (2nd string).
	case responseLocationHeaderResourceTypeMismatch(String, String)
	case responseNoResourceReceived
	
	/// The resource type received (1st string) does not match the expected type (2nd string).
	case responseResourceTypeMismatch(String, String)
	
	case operationConfigurationError(String)
	case operationInputParameterMissing(String)
	case operationNotSupported(String)
	
	case searchResourceTypeNotDefined
	
	/// JSON parsing failed for reason in 1st argument, full JSON string is 2nd argument.
	case jsonParsingError(String, String)
	
	// MARK: - CustomStringConvertible
	
	public var description: String {
		switch self {
			case .error(let message):
				return message
			
			case .resourceLocationUnknown:
				return "The location of the resource is not known".fhirLocalized
			case .resourceWithoutServer:
				return "The resource does not have a server instance assigned".fhirLocalized
			case .resourceWithoutId:
				return "The resource does not have an id, cannot proceed".fhirLocalized
			case .resourceAlreadyHasId:
				return "The resource already have an id, cannot proceed".fhirLocalized
			case .resourceFailedToInstantiate(let path, let error):
				return "\("Failed to instantiate resource when trying to read from".fhirLocalized) «\(path)»: \(error)"
			case .resourceFailedToValidate(let error):
				return "\("Failed to validate resource".fhirLocalized): \(error)"
			case .resourceCannotContainItself:
				return "A resource cannot contain itself".fhirLocalized

			case .requestCannotPrepareBody:
				return "`FHIRRequestHandler` cannot prepare request body data".fhirLocalized
			case .requestNotSent(let reason):
				return "\("Request not sent".fhirLocalized): \(reason)"
			case .requestError(let status, let message):
				return "\("Error".fhirLocalized) \(status): \(message)"
			case .noRequestHandlerAvailable(let type):
				return "\("No request handler is available for requests of type".fhirLocalized) “\(type.rawValue)”"
			case .noResponseReceived:
				return "No response received".fhirLocalized
			case .responseLocationHeaderResourceTypeMismatch(let location, let expectedType):
				return "\("“Location” header resource type mismatch. Expecting".fhirLocalized) “\(expectedType)” \("in".fhirLocalized) “\(location)”"
			case .responseNoResourceReceived:
				return "No resource data was received with the response".fhirLocalized
			case .responseResourceTypeMismatch(let receivedType, let expectedType):
				return "Returned resource is of wrong type, expected “\(expectedType)” but received “\(receivedType)”"
			
			case .operationConfigurationError(let message):
				return message
			case .operationInputParameterMissing(let name):
				return "\("Operation is missing input parameter".fhirLocalized): “\(name)”"
			case .operationNotSupported(let name):
				return "\("Operation is not supported".fhirLocalized): \(name)"
				
			case .searchResourceTypeNotDefined:
				return "Cannot find the resource type against which to run the search".fhirLocalized
			
			case .jsonParsingError(let reason, let raw):
				return "\("Failed to parse JSON".fhirLocalized): \(reason)\n\(raw)"
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
		if let verr = self as? FHIRValidationError {
			return FHIRError.resourceFailedToValidate(verr)
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
