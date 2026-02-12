/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import MGODebug

/// Protocol defining the interface for searching healthcare organizations.
///
/// Conforming types provide functionality to search through healthcare organization data,
/// manage search indexes, and retrieve version information about the search library.
///
/// Usage:
/// ```swift
/// let client = OrganizationSearchClient()
/// try await client.prepare()
/// let results = try await client.searchHealthcareOrganizations("hospital Amsterdam")
/// ```
public protocol OrganizationSearchClientProtocol {
	
	/// Initialize a new organization search client.
	init()
	
	/// Prepare the search index for querying.
	///
	/// This method must be called before performing searches. It loads organization data
	/// and builds the search index asynchronously.
	///
	/// - Throws: Errors related to loading organization data or building the index.
	func prepare() async throws
	
	/// Search for healthcare organizations matching the given search term.
	///
	/// The search term is matched against organization names, cities, and other relevant attributes.
	/// The search index must be prepared via `prepare()` before calling this method.
	///
	/// - Parameter searchTerm: The query string to search for (e.g., "hospital Amsterdam").
	/// - Returns: A `SearchResults` object containing matching organizations, or `nil` if no matches are found.
	/// - Throws: Errors if the search index is not prepared or if the search operation fails.
	func searchHealthcareOrganizations(_ searchTerm: String) async throws -> SearchResults?
	
	/// Retrieve the version information of the organization search library.
	///
	/// - Parameter fileName: The name of the version file (without extension). Defaults to "version".
	/// - Returns: A `Version` object containing library version information.
	/// - Throws: `Version.Error.noResource` if the version file cannot be found, or decoding errors if the file format is invalid.
	func getVersion(fileName: String) throws -> Version
}

/// JavaScript-backed implementation of healthcare organization search.
///
/// `OrganizationSearchClient` provides full-text search capabilities for healthcare organizations
/// using a JavaScript search engine running in an isolated actor context. It manages the lifecycle
/// of the search index and provides thread-safe access to search operations.
///
/// Implementation details:
/// - Uses `JSContextManager` to execute JavaScript-based search operations.
/// - All JavaScript operations are isolated on a background actor for thread safety.
/// - Supports iOS 15+ with optimized timing measurements on iOS 16+.
///
/// Example:
/// ```swift
/// let searchClient = OrganizationSearchClient()
/// try await searchClient.prepare() // Build the search index
/// let results = try await searchClient.searchHealthcareOrganizations("hospital")
/// let version = try searchClient.getVersion()
/// ```
public class OrganizationSearchClient: OrganizationSearchClientProtocol {
	
	/// The JavaScript context manager running on a background actor.
	///
	/// Handles all JavaScript execution, ensuring thread-safe access to the search engine.
	private let jsManager: JSContextManager
	
	/// Initialize a new JavaScript-backed organization search client.
	///
	/// Creates a new instance with a fresh JavaScript context manager.
	/// Call `prepare()` before performing searches.
	required public init() {
		jsManager = JSContextManager()
	}
	
	/// Prepare the search index for querying.
	///
	/// This method loads organization data from bundled resources and builds a searchable index.
	/// It must be called once before any search operations. The operation is asynchronous and
	/// may take several seconds depending on the dataset size.
	///
	/// - Throws: Errors if organization data cannot be loaded or if index creation fails.
	public func prepare() async throws {
		try await jsManager.createIndex()
	}
	
	/// Search for healthcare organizations matching the given search term.
	///
	/// Performs a full-text search against the indexed organization data. The search term
	/// is matched against organization names, cities, and other attributes.
	///
	/// - Parameter searchTerm: The query string to search for (e.g., "hospital Amsterdam", "cardiology").
	/// - Returns: A `SearchResults` object containing matching organizations, or `nil` if no matches are found.
	/// - Throws: Errors if the search index has not been prepared or if the search operation fails.
	public func searchHealthcareOrganizations(_ searchTerm: String) async throws -> SearchResults? {
		return try await jsManager.searchHealthcareOrganizations(searchTerm)
	}
	
	/// Retrieve version information for the organization search library.
	///
	/// Reads version metadata from a bundled JSON file to provide information about
	/// the search library version, build date, and other metadata.
	///
	/// - Parameter fileName: The name of the version file (without extension). Defaults to "version".
	/// - Returns: A `Version` object containing library version information.
	/// - Throws:
	///   - `Version.Error.noResource` if the version file cannot be found.
	///   - Decoding errors if the version file format is invalid.
	public func getVersion(fileName: String = "version") throws -> Version {
		
		guard let parserPath = Bundle.module.path(forResource: fileName, ofType: "json") else {
			logError("OrganizationSearchClient: The version file could not be found")
			throw Version.Error.noResource
		}
		
		return try Version(String(contentsOfFile: parserPath))
	}
}
