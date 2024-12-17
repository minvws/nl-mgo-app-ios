/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient
import FHIRParser

public class MGORepository {
	
	/// The FHIR Client
	private var client: FHIRClient
	
	/// Initializer
	/// - Parameter client: the FHIR client
	public init(client: FHIRClient) {
		self.client = client
	}
	
	/// Get the Bundle from the DVP as data
	/// - Parameters:
	///   - endpoint: the endpoint to use
	///   - dvaTarget: the dva target
	/// - Returns: Bundle as data.
	public func getBundleData(endpoint: DVP.Endpoint, dvaTarget: String, username: String?, password: String?) async throws -> Data {
		
		var path = endpoint.path
		if let directory = endpoint.directory {
			path += "/\(directory)"
		}
		
		var parameters = RequestParameters()
		if let params = endpoint.parameters {
			parameters = params
		}
		
		var headers: [RequestHeaderField: String] = [RequestHeaderField.dvaTarget: dvaTarget]
		if let basicAuth = basicAuthenticationHeader(username: username, password: password) {
			headers[RequestHeaderField.authorization] = basicAuth
		}
		let data = try await client.readDataFrom(
			path,
			parameters: parameters,
			options: [],
			headers: RequestHeaders(headers)
		)
		
		return data
	}
	
	private func basicAuthenticationHeader(username: String?, password: String?) -> String? {
		
		guard let username, let password else { return nil }
		
		let loginString = String(format: "%@:%@", username, password)
		let loginData = Data(loginString.utf8)
		let base64LoginString = loginData.base64EncodedString()
		return "Basic \(base64LoginString)"
	}
	
	/// process the bundle FHIR data into mgoResources
	/// - Parameter data: FHIR bundle
	/// - Returns: array of mgoResources (as Data)
	public func process(_ data: Data, fhirVersion: String) throws -> [MgoResource] {
		
		// The parser
		let parser = FHIRParser()
		
		// Transform the bundle into FHIR resources
		let fhirResources = parser.getBundleResourcesJson(data)
		
		// The result set
		var mgoResources = [MgoResource]()
	
		// Loop over all FHIR resources
		for element in fhirResources {
			// Cast to data
			let resource = try JSONSerialization.data(withJSONObject: element)
			
			// Transfrom to MgoResource
			if let mgoResource = parser.getMgoResourceJson(resource, fhirVersion: fhirVersion) {
				mgoResources.append(mgoResource)
			}
		}
		return mgoResources
	}
}
