/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import MGODebug

public protocol OrganizationSearchClientProtocol: Actor {
	
	/// Create a Organization Search Client
	init()
	
	/// Search for all the healthcare organizations with this term
	/// - Parameters:
	///   - city: the city to search with
	///   - name: the name to search with
	/// - Returns: An (empty) array of Healthcare Organizations
	func searchHealthcareOrganizations(_ searchTerm: String) async throws -> [Data]
	
	/// Get the version of the organization search library
	/// - Returns: the organization search version
	@MainActor func getVersion() throws -> Version
}

public actor OrganizationSearchClient: OrganizationSearchClientProtocol {
	
	/// Create a Organization Search Client
	public init() {}
	
	/// Search for all the healthcare organizations with this term
	/// - Parameters:
	///   - city: the city to search with
	///   - name: the name to search with
	/// - Returns: An (empty) array of Healthcare Organizations
	public func searchHealthcareOrganizations(_ searchTerm: String) async throws -> [Data] {
		return []
	}
	
#warning("Rool, 02/12/2025: Should this be a mainactor function on this actor?")
	/// What version of the shared core are we running?
	/// - Returns: the version
	@MainActor public func getVersion() throws -> Version {
		
		guard let parserPath = Bundle.module.path(forResource: "version", ofType: "json") else {
			logError("OrganizationSearchClient: The version file could not be found")
			throw Version.Error.noResource
		}
		
		return try Version(String(contentsOfFile: parserPath))
	}
}
