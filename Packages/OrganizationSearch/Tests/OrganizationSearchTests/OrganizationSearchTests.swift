/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import OrganizationSearch
import Testing

class OrganizationSearchClientTests {
	
	@Test("Search for an organization")
	func search() async throws {
		
		// Given
		let sut = OrganizationSearchClient()
		let searchTerm = "Test"
		try await sut.prepare()
		
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
		await #expect(throws: JSContextManagerError.noIndex) {
			try await sut.searchHealthcareOrganizations(searchTerm)
		}
	}
	
	@Test("Check the version of the Organization Search Package")
	func checkVersion() throws {
		
		// Given
		let sut = OrganizationSearchClient()
		
		// When
		let result = try sut.getVersion()
		
		// Then
		#expect(result.version == "main-9c41ae0")
		#expect(result.gitRef == "9c41ae007176014905eb7a68d383a74c5b621b60")
		#expect(result.created == "2026-02-10T15:20:05")
	}
}
