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
	public var invokedGetVersionParameters: (fileName: String, Void)?
	public var invokedGetVersionParametersList = [(fileName: String, Void)]()
	public var stubbedGetVersionError: Error?
	public var stubbedGetVersionResult: Version!

	public func getVersion(fileName: String = "version") throws -> Version {
		invokedGetVersion = true
		invokedGetVersionCount += 1
		invokedGetVersionParameters = (fileName, ())
		invokedGetVersionParametersList.append((fileName, ()))
		if let error = stubbedGetVersionError {
			throw error
		}
		return stubbedGetVersionResult
	}

	public var invokedPrepare = false
	public var invokedPrepareCount = 0
	public var invokedPrepareParameters: (dataset: OrganizationDataset, Void)?
	public var invokedPrepareParametersList = [(dataset: OrganizationDataset, Void)]()

	public func prepare(dataset: OrganizationDataset = .full) async throws {
		invokedPrepare = true
		invokedPrepareCount += 1
		invokedPrepareParameters = (dataset, ())
		invokedPrepareParametersList.append((dataset, ()))
	}
}
