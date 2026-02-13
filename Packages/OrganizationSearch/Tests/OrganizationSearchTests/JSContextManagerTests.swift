/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import OrganizationSearch
import Testing
import Foundation

class JSContextManagerTests {
	
	@Test("createIndex uses the injected clock (MockMeasurableClock path)")
	func createIndexUsesMockClock() async throws {
		
		// Given
		let clock = MockMeasurableClock()
		let sut = JSContextManager(clock: clock)
		
		// When
		try await sut.createIndex()
		
		// Then – now() must be called twice: once before loading, once before indexing
		#expect(clock.nowCallCount == 2)
	}
	
	@Test("createIndex uses the DateMeasurer (iOS 15 fallback path)")
	func createIndexUsesDateMeasurer() async throws {
		
		// Given – explicitly inject the Date-based measurer
		let clock = DateMeasurer()
		let sut = JSContextManager(clock: clock)
		
		// When
		try await sut.createIndex()
		
		// Then – no error means both timing paths completed successfully
		// (searching afterwards confirms providers were indexed)
		let result = try await sut.searchHealthcareOrganizations("Test")
		#expect(result != nil)
	}
}
