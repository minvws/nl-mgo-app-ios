/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient

public struct DVP {
	
	public struct Endpoint {
		
		/// Create an Dataset Endpoint
		/// - Parameters:
		///   - path: the resource path
		///   - parameters: the request params
		///   - directory: the url directory
		///   - serviceId: the identifier of the service
		public init(path: String, parameters: RequestParameters? = nil, directory: String? = nil, serviceId: String) {
			self.path = path
			self.parameters = parameters
			self.directory = directory
			self.serviceId = serviceId
		}
		
		/// The path for this endpoint
		public let path: String
		
		/// Any request parameters?
		public let parameters: RequestParameters?
		
		/// Any directory?
		public let directory: String?
		
		/// The identifier of the service
		public let serviceId: String
	}
}
