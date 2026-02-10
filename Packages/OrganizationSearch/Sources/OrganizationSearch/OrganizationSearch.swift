/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import MGODebug

public protocol OrganizationSearchClientProtocol {
	
	/// Create a Organization Search Client
	init()
	
	/// Search for all the healthcare organizations with this term
	/// - Parameters:
	///   - city: the city to search with
	///   - name: the name to search with
	/// - Returns: An (empty) array of Healthcare Organizations
	func searchHealthcareOrganizations(_ searchTerm: String) async throws -> SearchResults?
	
	/// Get the version of the organization search library
	/// - Returns: the organization search version
	func getVersion() throws -> Version
	
	/// Prepare the organizations to be searched
	func prepare() async throws
}

public class OrganizationSearchClient: OrganizationSearchClientProtocol {
	
	/// The JavaScript context manager running on a background actor
	private let jsManager: JSContextManager
	
	/// Create a JS backed Organization Search
	required public init() {
		jsManager = JSContextManager()
	}
	
	/// Prepare the organizations to be searched
	public func prepare() async throws {
		try await jsManager.createIndex()
	}
	
	/// Search for all the healthcare organizations with this term
	/// - Parameters:
	///   - searchTerm: the search term
	/// - Returns: optional Search result
	public func searchHealthcareOrganizations(_ searchTerm: String) async throws -> SearchResults? {
		return try await jsManager.searchHealthcareOrganizations(searchTerm)
	}
	
	/// Get the version of the organization search library
	/// - Returns: the organization search version
	public func getVersion() throws -> Version {
		
		guard let parserPath = Bundle.module.path(forResource: "version", ofType: "json") else {
			logError("OrganizationSearchClient: The version file could not be found")
			throw Version.Error.noResource
		}
		
		return try Version(String(contentsOfFile: parserPath))
	}
}
