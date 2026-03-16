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
		#expect(result.version == "main-ef55529")
		#expect(result.gitRef == "ef55529d311945a433dcd33722c8df1c07dc0adc")
		#expect(result.created == "2026-03-13T08:20:07")
	}
}
