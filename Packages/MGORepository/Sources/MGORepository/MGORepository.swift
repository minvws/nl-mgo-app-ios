/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient
import SharedCore

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
			path.append("/\(directory)")
		}
		
		var parameters = RequestParameters()
		if let params = endpoint.parameters {
			parameters = params
		}
		
		var headers: [RequestHeaderField: String] = [
			RequestHeaderField.dvaTarget: dvaTarget,
			RequestHeaderField.accept: endpoint.fhirVersion.acceptHeader
		]
		if let basicAuth = basicAuthenticationHeader(username: username, password: password) {
			headers[RequestHeaderField.authorization] = basicAuth
		}
		let data = try await client.readDataFrom(
			path,
			parameters: parameters,
			headers: RequestHeaders(headers)
		)
		
		return data
	}
	
	/// The Basic Auth header value
	/// - Parameters:
	///   - username: username
	///   - password: password
	/// - Returns: Basis Auth header value
	private func basicAuthenticationHeader(username: String?, password: String?) -> String? {
		
		guard let username, let password else { return nil }
		
		let loginString = String(format: "%@:%@", username, password)
		let loginData = Data(loginString.utf8)
		let base64LoginString = loginData.base64EncodedString()
		return "Basic \(base64LoginString)"
	}
	
	// The FHIR parser
	let parser = FHIRParser()

	/// process the bundle FHIR data into mgoResources
	/// - Parameter data: FHIR bundle
	/// - Returns: array of mgoResources (as Data)
	public func process(_ bundle: Data, fhirVersion: String) throws -> [MgoResource] {
		
		// Split the bundle into FHIR resources
		let fhirResources = parser.splitBundleIntoResources(bundle)
		
		// The result set
		var mgoResources = [MgoResource]()
	
		// Loop over all FHIR resources
		for element in fhirResources {
			
			// Transform to MgoResource
			if let mgoResource = parser.transformFHIRResourceIntoMGOResource(element, fhirVersion: fhirVersion) {
				mgoResources.append(mgoResource)
			}
		}
		return mgoResources
	}
}
