/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import OrganizationSearch
import Testing
import Foundation

class OrganizationSearchClientTests {
	
	@Test("Search for an organization")
	func search() async throws {
		
		// Given
		let sut = OrganizationSearchClient()
		let searchTerm = "Testtest"
		try await sut.prepare(dataset: .test)
		
		// When
		let searchResult = try? await sut.searchHealthcareOrganizations(searchTerm)
		
		// Then
		#expect(searchResult != nil)
		#expect(searchResult?.count == 9.0)
	}
	
	@Test("Search for an organization without indexing")
	func searchWithoutIndexing() async throws {
		
		// Given
		let sut = OrganizationSearchClient()
		let searchTerm = "Test"
		
		// When / Then
		await #expect(throws: OrganizationSearchError.notPrepared) {
			try await sut.searchHealthcareOrganizations(searchTerm)
		}
	}
	
	@Test("Check the version of the Organization Search Package")
	func checkVersion() throws {
		
		// Given
		let sut = OrganizationSearchClient()
		
		// When / Then
		#expect(throws: Version.Error.noResource) {
			try sut.getVersion()
		}
	}
}
