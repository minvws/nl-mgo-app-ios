/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient
import HCIMCore
import MGODebug

/// The repository to fetch FHIR data and store as HCIM
public actor MGORepository {
	
	/// The FHIR Client
	private let client: FHIRClient
	
	/// Create the MGO Repository
	/// - Parameter client: the FHIR client
	public init(client: FHIRClient) {
		self.client = client
	}
	
	/// What version of the shared core are we running?
	/// - Returns: the version
	@MainActor public func getVersion() throws -> SharedVersion {
		
		guard let parserPath = Bundle.module.path(forResource: "version", ofType: "json") else {
			logError("MGORepository: The version file could not be found")
			throw SharedVersion.Error.noResource
		}
		
		return try SharedVersion(String(contentsOfFile: parserPath))
	}
	
	/// Get the Bundle from a DVP Endpoint as data
	/// - Parameters:
	///   - endpoint: the endpoint to use
	///   - fhirVersion: the FHIR version expected as response
	///   - headers: the MGO request headers
	/// - Returns: Bundle as data.
	public func getBundleData(
		endpoint: DataServices.Endpoint,
		fhirVersion: DataServices.FhirVersion,
		headers: MGORepositoryHeaders
	) async throws -> Data {
		
		var path = endpoint.getPath()
		if let first = path.first, first == "/" {
			path = String(path.dropFirst())
		}
		
		var requestHeaders: [RequestHeaderField: String] = [
			RequestHeaderField.dvaTarget: headers.dvaTarget,
			RequestHeaderField.accept: fhirVersion.acceptHeader,
			RequestHeaderField.dataServiceId: headers.dataServiceId,
			RequestHeaderField.providerId: headers.medmijId ?? "none" // defaults to none.
		]
		
		if let basicAuth = basicAuthenticationHeader(
			username: headers.username,
			password: headers.password) {
			requestHeaders[RequestHeaderField.authorization] = basicAuth
		}
		let data = try await client.readDataFrom(
			path,
			headers: RequestHeaders(requestHeaders)
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
	
	// The HCIM parser
	let parser = HCIMParser()

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
			if let mgoResource = parser.transformFHIRResourceIntoHCIM(
				element,
				fhirVersion: fhirVersion) {
				mgoResources.append(mgoResource)
			}
		}
		return mgoResources
	}
}
