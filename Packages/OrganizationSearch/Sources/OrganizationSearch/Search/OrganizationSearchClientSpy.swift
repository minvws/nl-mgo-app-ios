/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// Test double for `OrganizationSearchClientProtocol`.
///
/// Records every call made to its methods and exposes the captured arguments
/// via `invoked*` and `invokedParameters*` properties. Return values can be
/// configured through `stubbed*` properties before the call is made.
public class OrganizationSearchClientSpy: OrganizationSearchClientProtocol, @unchecked Sendable {
	
	public required init() {
		// Public init required
	}
	
	public var invokedPrepare = false
	public var invokedPrepareCount = 0
	public var invokedPrepareParameters: (dataset: OrganizationDataset, Void)?
	public var invokedPrepareParametersList = [(dataset: OrganizationDataset, Void)]()
	public var stubbedPrepareError: Error?
	
	public func prepare(dataset: OrganizationDataset) async throws {
		invokedPrepare = true
		invokedPrepareCount += 1
		invokedPrepareParameters = (dataset, ())
		invokedPrepareParametersList.append((dataset, ()))
		if let error = stubbedPrepareError {
			throw error
		}
	}
	
	public var invokedTeardown = false
	public var invokedTeardownCount = 0
	
	public func teardown() async {
		invokedTeardown = true
		invokedTeardownCount += 1
	}
	
	public var invokedSearchHealthcareOrganizations = false
	public var invokedSearchHealthcareOrganizationsCount = 0
	public var invokedSearchHealthcareOrganizationsParameters: (searchTerm: String, Void)?
	public var invokedSearchHealthcareOrganizationsParametersList = [(searchTerm: String, Void)]()
	public var stubbedSearchHealthcareOrganizationsSearchResults: SearchResults!
	
	public func searchHealthcareOrganizations(_ searchTerm: String) async throws -> SearchResults {
		invokedSearchHealthcareOrganizations = true
		invokedSearchHealthcareOrganizationsCount += 1
		invokedSearchHealthcareOrganizationsParameters = (searchTerm, ())
		invokedSearchHealthcareOrganizationsParametersList.append((searchTerm, ()))
		return stubbedSearchHealthcareOrganizationsSearchResults
	}
}
