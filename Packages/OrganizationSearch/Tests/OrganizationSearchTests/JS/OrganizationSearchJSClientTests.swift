/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import OrganizationSearch
import Testing
import Foundation

class OrganizationSearchJSClientTests {
	
	@Test("Search for an organization")
	func search() async throws {
		
		// Given
		let sut = OrganizationSearchJSClient()
		let searchTerm = "Test"
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
		let sut = OrganizationSearchJSClient()
		let searchTerm = "Test"
		
		// When / Then
		await #expect(throws: JSContextManagerError.noIndex) {
			try await sut.searchHealthcareOrganizations(searchTerm)
		}
	}
	
	@Test("Check the version of the Organization Search Package")
	func checkVersion() throws {
		
		// Given
		let sut = OrganizationSearchJSClient()
		
		// When
		let result = try sut.getVersion()
		
		// Then
		#expect(result.version == "main-9c41ae0")
		#expect(result.gitRef == "9c41ae007176014905eb7a68d383a74c5b621b60")
		#expect(result.created == "2026-02-10T15:20:05")
	}
	
	@Test("Get version throws noResource error when file does not exist")
	func getVersionWithInvalidFileName() throws {
		
		// Given
		let sut = OrganizationSearchJSClient()
		let invalidFileName = "nonexistent-version-file"
		
		// When / Then
		#expect(throws: Version.Error.noResource) {
			_ = try sut.getVersion(fileName: invalidFileName)
		}
	}
}
