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
		let result: SharedVersion = try await sut.getVersion()
		
		// Then
		#expect(result.version == "main")
		#expect(result.gitRef == "cceb73c75f4a524f5ab753bab29ceff16e2d23d2")
		#expect(result.created == nil)
	}
}
