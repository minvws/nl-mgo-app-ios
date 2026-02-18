/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import SecureUserSettings

final class SecureUserSettingsTests: XCTestCase {
	
	var sut: SecureUserSettings!
	
	override func setUp() {
		
		super.setUp()
		sut = SecureUserSettings()
		sut.wipePersistedData()
	}
	
	override func tearDown() {
		
		super.tearDown()
		sut.wipePersistedData()
	}

	func test_secureUserSettings_wipePersistedData() {
		
		// Given
		sut.userHasSeenJailBreakWarning = true
		sut.userHasRemoteAuthentication = true
		sut.enteredBackground = Date()
		
		// When
		sut.wipePersistedData()
		
		// Then
		expect(self.sut.userHasSeenJailBreakWarning) == false
		expect(self.sut.userHasRemoteAuthentication) == false
		expect(self.sut.enteredBackground) == nil
	}
	
	func test_secureUserSettings_setUserHasRemoteAuthentication() {
		
		// Given
		expect(self.sut.userHasRemoteAuthentication) == false
		
		// When
		sut.userHasRemoteAuthentication = true
		
		// Then
		expect(self.sut.userHasRemoteAuthentication) == true
	}
	
	func test_secureUserSettings_setUserHasSeenJailBreakWarning() {
		
		// Given
		expect(self.sut.userHasSeenJailBreakWarning) == false
		
		// When
		sut.userHasSeenJailBreakWarning = true
		
		// Then
		expect(self.sut.userHasSeenJailBreakWarning) == true
	}
	
	func test_secureUserSettings_setEnteredBackground() {
		
		// Given
		expect(self.sut.enteredBackground) == nil
		let timestamp = Date()
		
		// When
		sut.enteredBackground = timestamp
		
		// Then
		expect(self.sut.enteredBackground) == timestamp
	}
	
	func test_secureUserSettings_setFirstTimeVisitor() {
		
		// Given
		expect(self.sut.firstTimeVisitor) == true
		
		// When
		sut.firstTimeVisitor = false
		
		// Then
		expect(self.sut.firstTimeVisitor) == false
	}
}
