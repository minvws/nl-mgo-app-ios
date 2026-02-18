/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import Testing
@testable import SecureUserSettings

@Suite
struct SecureUserSettingsTests {
	
	var sut: SecureUserSettings
	
	init() {
		sut = SecureUserSettings()
		sut.wipePersistedData()
	}
	
	@Test
	func wipePersistedData() {
		
		// Given
		sut.userHasSeenJailBreakWarning = true
		sut.firstTimeVisitor = false
		
		// When
		sut.wipePersistedData()
		
		// Then
		#expect(sut.userHasSeenJailBreakWarning == false)
		#expect(sut.firstTimeVisitor == true)
	}
	
	@Test
	func setUserHasSeenJailBreakWarning() {
		
		// Given
		#expect(sut.userHasSeenJailBreakWarning == false)
		
		// When
		sut.userHasSeenJailBreakWarning = true
		
		// Then
		#expect(sut.userHasSeenJailBreakWarning == true)
	}
	
	@Test
	func setFirstTimeVisitor() {
		
		// Given
		#expect(sut.firstTimeVisitor == true)
		
		// When
		sut.firstTimeVisitor = false
		
		// Then
		#expect(sut.firstTimeVisitor == false)
	}
}
