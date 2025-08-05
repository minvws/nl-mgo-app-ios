/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import JailBreakDetector
import Testing

@MainActor
struct JailBreakDetectorTests {
	
	@Test func isJailBroken_shouldReturnFalseOnSimulator() async throws {
		
		// Given
		let subjectUnderTest = JailBreakDetector()
		
		// When
		let result = subjectUnderTest.isJailBroken()
		
		// Then
		#expect(!result)
	}
}
