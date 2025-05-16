/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient

public struct DVP {
	
	/// Potential FHIR versions of the response
	public enum FhirVersion: String {
		case r3 = "R3"
		case r4 = "R4"
		
		var acceptHeader: String {
			switch self {
				case .r3:
					return "application/json+fhir; fhirVersion=3.0"
				case .r4:
					return "application/json+fhir; fhirVersion=4.0"
			}
		}
	}
	
	public struct Endpoint {
		
		/// Create an Dataset Endpoint
		/// - Parameters:
		///   - path: the resource path
		///   - parameters: the request params
		///   - directory: the url directory
		///   - serviceId: the identifier of the service
		///   - fhirVersion: The FHIR version of the resource
		
		public init(
			path: String,
			parameters: RequestParameters? = nil,
			directory: String? = nil,
			serviceId: String,
			fhirVersion: DVP.FhirVersion = .r3) {
			self.path = path
			self.parameters = parameters
			self.directory = directory
			self.serviceId = serviceId
			self.fhirVersion = fhirVersion
		}
		
		/// The path for this endpoint
		public let path: String
		
		/// Any request parameters?
		public let parameters: RequestParameters?
		
		/// Any directory?
		public let directory: String?
		
		/// The identifier of the service
		public let serviceId: String
		
		/// The FHIR version of the resource
		public let fhirVersion: DVP.FhirVersion
	}
}
