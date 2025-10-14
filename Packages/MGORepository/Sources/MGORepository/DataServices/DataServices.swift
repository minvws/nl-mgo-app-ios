/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import MGODebug

public struct DataServices: Sendable {
	
	// MARK: - FHIR
	
	/// Potential FHIR versions of the response
	public enum FhirVersion: String, Sendable, Codable {
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
	
	// MARK: - Endpoint
	
	/// The endpoint for the server to call
	public struct Endpoint: Codable, Equatable, Sendable, Identifiable, Hashable {
		
		/// The identifier of the endpoint
		public let id: String
		
		/// The relative url to the resource
		private let path: String
		
		/// The profiles this endpoint is good for
		public let profiles: [String]
		
		/// Create an endpoint
		/// - Parameters:
		///   - id:  The identifier of the endpoint
		///   - path: The relative path to the resource
		///   - profiles: The profiles this endpoint is good for
		public init(id: String, path: String, profiles: [String]) {
			self.id = id
			self.path = path
			self.profiles = profiles
		}
		
		static let dateFormatter: DateFormatter = {
			let formater = DateFormatter()
			formater.timeZone = TimeZone(abbreviation: "CET")
			formater.dateFormat = "yyyy-MM-dd"
			
			return formater
		}()
		
		/// Get the path for this endpoint
		/// - Parameter date: optional date
		/// - Returns: the path for this endpoint
		public func getPath(_ date: Date = Date()) -> String {
			return path.replacingOccurrences(of: "{{today}}", with: DataServices.Endpoint.dateFormatter.string(from: date))
		}
	}
	
	/// The data service with an array of endpoints
	public struct DataService: Codable, Equatable, Identifiable, Sendable {
		
		/// The identifier of the data service
		public let id: String
		
		/// The name of the data service
		public let name: String
		
		/// The FHIR version of the data service
		public let fhirVersion: FhirVersion
		
		/// The endpoints for the data service
		public let endpoints: [Endpoint]
		
		/// Create a Data Service
		/// - Parameters:
		///   - id: The identifier of the data service
		///   - name: The name of the data service
		///   - fhirVersion: The FHIR version of the data service
		///   - endpoints: The endpoints for the data service
		public init(id: String, name: String, fhirVersion: FhirVersion, endpoints: [Endpoint]) {
			self.id = id
			self.name = name
			self.fhirVersion = fhirVersion
			self.endpoints = endpoints
		}
	}
	
	/// the Health Categories Error
	public enum Error: Swift.Error, Sendable {
		
		/// No resource files found
		case noResources
	}
	
	public var services: [DataService] = []
	
	/// Create the data services
	public init(isDemo: Bool = false) {
		
		var elements = [String]()
		if let files = try? FileManager.default.contentsOfDirectory(atPath: Bundle.module.bundlePath) {
			
			elements = files
				// Only allow the dataservices
				.filter({ $0.hasSuffix(".json") && $0 != "version.json" })
				// Strip the .json suffix
				.map({ $0.replacingOccurrences(of: ".json", with: "") })
				// Adjust for demo
				.filter({
					if isDemo {
						$0.hasSuffix("demo")
					} else {
						!$0.hasSuffix("demo")
					}
				})
		}
		for element in elements {
			if let service = try? loadService(element) {
				services.append(service)
			}
		}
	}
	
	/// Load a service
	/// - Parameter identifier: the identifier of the service to load, i.e. 48, 49. 51, 63 etc
	/// - Returns: the data service
	private func loadService(_ identifier: String) throws -> DataService {
		
		guard let resourcePath = Bundle.module.path(forResource: identifier, ofType: "json") else {
			logError("DataServices.Error: No resources found")
			throw DataServices.Error.noResources
		}
		let data = try Data(contentsOf: URL(fileURLWithPath: resourcePath))
		
		do {
			return try JSONDecoder().decode(DataService.self, from: data)
		} catch {
			logError("error", error)
			throw error
		}
	}
}
