/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

/// Skeleton implementation of `OrganizationSearchClientProtocol`.
///
/// Replace this implementation with the desired search strategy.
public class OrganizationSearchClient: OrganizationSearchClientProtocol {
	
	required public init() {}
	
	public func prepare() async throws {}
	
	public func searchHealthcareOrganizations(_ searchTerm: String) async throws -> SearchResults? {
		return nil
	}
	
	public func getVersion(fileName: String = "version") throws -> Version {
		throw Version.Error.noResource
	}
}
