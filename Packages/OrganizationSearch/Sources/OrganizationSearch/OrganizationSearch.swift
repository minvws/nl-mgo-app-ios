/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

/// Protocol defining the interface for searching healthcare organizations.
///
/// Conforming types provide functionality to search through healthcare organization data,
/// manage search indexes, and retrieve version information about the search library.
///
/// Usage:
/// ```swift
/// let client = OrganizationSearchClient()
/// try await client.prepare(dataset: .medmij)   // or just .prepare() for the full set
/// let results = try await client.searchHealthcareOrganizations("hospital Amsterdam")
/// ```
public protocol OrganizationSearchClientProtocol {
	
	/// Initialize a new organization search client.
	init()
	
	/// Prepare the search index for querying.
	///
	/// This method must be called before performing searches. It loads organization data
	/// from the specified dataset and builds the search index asynchronously.
	///
	/// - Parameter dataset: The organization dataset to load. Defaults to `.full`.
	/// - Throws: Errors related to loading organization data or building the index.
	func prepare(dataset: OrganizationDataset) async throws
	
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

public extension OrganizationSearchClientProtocol {

	/// Prepare the search index using the full organization dataset.
	///
	/// Convenience overload that calls `prepare(dataset:)` with `.full`.
	func prepare() async throws {
		try await prepare(dataset: .full)
	}
}

