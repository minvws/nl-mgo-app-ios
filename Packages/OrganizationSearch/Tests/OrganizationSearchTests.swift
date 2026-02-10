/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import OrganizationSearch
import Testing

class OrganizationSearchClientTests {
	
	@Test
	func getVersion() async throws {
		
		// Given
		let sut = OrganizationSearchClient()
		
		// When
		let result = try await sut.getVersion()
		
		// Then
		#expect(result.version == "1138/merge-080940a")
		#expect(result.gitRef == "080940afd9a343b2460afacaa848a2e4f2bca7f8")
		#expect(result.created == "2026-02-05T09:44:58")
	}
}
