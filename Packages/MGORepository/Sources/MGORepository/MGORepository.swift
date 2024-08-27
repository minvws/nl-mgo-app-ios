/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient

public class MGORepository {
	
	/// The FHIR Client
	private var client: FHIRClient
	
	/// Initializer
	/// - Parameter client: the FHIR client
	public init(client: FHIRClient) {
		self.client = client
	}
	
	/// Get a STU3 Bundle from the endpoint
	/// - Parameters:
	///   - endpoint: the endpoint to use
	///   - dvaTarget: the target
	/// - Returns: STU3.Bundle
	public func getBundle(endpoint: DVP.Endpoint, dvaTarget: String) async throws -> ModelsSTU3.Bundle? {
		
		var path = endpoint.path
		if let directory = endpoint.directory {
			path += "/\(directory)"
		}
		
		var parameters = RequestParameters()
		if let params = endpoint.parameters {
			parameters = params
		}
		
		let resource = try await ModelsSTU3.Resource.readResourceFrom(
			path,
			client: client,
			parameters: parameters,
			options: [],
			headers: RequestHeaders([RequestHeaderField.dvaTarget: dvaTarget])
		)
		
		return resource as? ModelsSTU3.Bundle
	}
	
	/// Get the Bundle from the DVP as data
	/// - Parameters:
	///   - endpoint: the endpoint to use
	///   - dvaTarget: the dva target
	/// - Returns: Bundle as data.
	public func getBundleData(endpoint: DVP.Endpoint, dvaTarget: String) async throws -> Data {
		
		var path = endpoint.path
		if let directory = endpoint.directory {
			path += "/\(directory)"
		}
		
		var parameters = RequestParameters()
		if let params = endpoint.parameters {
			parameters = params
		}
		
		let data = try await client.readDataFrom(
			path,
			parameters: parameters,
			options: [],
			headers: RequestHeaders([RequestHeaderField.dvaTarget: dvaTarget])
		)
		
		return data
	}
}
