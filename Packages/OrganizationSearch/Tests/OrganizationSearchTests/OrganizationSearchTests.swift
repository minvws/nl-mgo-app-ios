/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import OrganizationSearch
import Testing

class OrganizationSearchClientTests {
	
	@Test("Check the version of the Organization Search Package")
	func checkVersion() async throws {
		
		// Given
		let sut = OrganizationSearchClient()
		
		// When
		let result = try await sut.getVersion()
		
		// Then
		#expect(result.version == "main-9c41ae0")
		#expect(result.gitRef == "9c41ae007176014905eb7a68d383a74c5b621b60")
		#expect(result.created == "2026-02-10T15:20:05")
	}
}
