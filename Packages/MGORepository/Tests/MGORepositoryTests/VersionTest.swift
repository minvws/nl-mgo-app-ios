/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
		let result: SharedCategoriesVersion = try sut.getVersion()
		
		// Then
		#expect(result.version == "main-1838907")
		#expect(result.gitRef == "18389071ae95fe16b1d56f0a5fd5773368decaae")
		#expect(result.created == "2026-01-28T14:12:35")
	}
}
