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
		let result: SharedVersion = try sut.getVersion()
		
		// Then
		#expect(result.version == "main")
		#expect(result.gitRef == "aeb3319adce9873d7456987d433b24bfb9c320ce")
		#expect(result.created == "2025-11-26T14:42:53")
	}
}
