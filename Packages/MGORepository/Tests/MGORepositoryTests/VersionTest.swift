/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import Foundation
import Testing
import FHIRClient

@MainActor
struct SharedVersionTests {
	
	@Test func getVersion() async throws {
		
		// Given
		let serverUrl = try #require(URL(string: "https://example.com"))
		let client = FHIRClient(baseURL: serverUrl)
		let sut = MGORepository(client: client)
		
		// When
		let result: SharedCategoriesVersion = try await sut.getVersion()
		
		// Then
		#expect(result.version == "main-cdaedbe")
		#expect(result.gitRef == "cdaedbe30128751894052bc385a291a82eae0d7e")
		#expect(result.created == "2026-05-19T14:38:12")
	}
}
