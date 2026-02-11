/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public class OrganizationSearchClientSpy: OrganizationSearchClientProtocol {

	public required init() {
		// Public init required
	}

	public var invokedSearchHealthcareOrganizations = false
	public var invokedSearchHealthcareOrganizationsCount = 0
	public var invokedSearchHealthcareOrganizationsParameters: (searchTerm: String, Void)?
	public var invokedSearchHealthcareOrganizationsParametersList = [(searchTerm: String, Void)]()
	public var stubbedSearchHealthcareOrganizationsSearchResults: SearchResults?

	public func searchHealthcareOrganizations(_ searchTerm: String) async throws -> SearchResults? {
		invokedSearchHealthcareOrganizations = true
		invokedSearchHealthcareOrganizationsCount += 1
		invokedSearchHealthcareOrganizationsParameters = (searchTerm, ())
		invokedSearchHealthcareOrganizationsParametersList.append((searchTerm, ()))
		return stubbedSearchHealthcareOrganizationsSearchResults
	}

	public var invokedGetVersion = false
	public var invokedGetVersionCount = 0
	public var stubbedGetVersionError: Error?
	public var stubbedGetVersionResult: Version!

	public func getVersion() throws -> Version {
		invokedGetVersion = true
		invokedGetVersionCount += 1
		if let error = stubbedGetVersionError {
			throw error
		}
		return stubbedGetVersionResult
	}

	public var invokedPrepare = false
	public var invokedPrepareCount = 0

	public func prepare() {
		invokedPrepare = true
		invokedPrepareCount += 1
	}
}
