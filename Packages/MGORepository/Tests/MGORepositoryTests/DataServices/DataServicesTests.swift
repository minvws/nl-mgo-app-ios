/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import Testing
import Foundation

class DataServicesTests {
	
	var sut: DataServices!
	
	init() {
		self.sut = DataServices()
	}
	
	@Test func initializer() async throws {
		
		// Given
		
		// When
		
		// Then
		#expect(sut.services.count == 6)
	}
}
