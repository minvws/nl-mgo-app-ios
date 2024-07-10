/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
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
		sut.userHasSeenAppIntroduction = true
		sut.userHasSeenJailBreakWarning = true
		sut.userHasRemoteAuthentication = true
		sut.bioMetricAuthenticationEnabled = true
		sut.pinCode = "TEST"
		
		// When
		sut.wipePersistedData()
		
		// Then
		expect(self.sut.userHasSeenAppIntroduction) == false
		expect(self.sut.userHasSeenJailBreakWarning) == false
		expect(self.sut.userHasRemoteAuthentication) == false
		expect(self.sut.bioMetricAuthenticationEnabled) == false
		expect(self.sut.pinCode) == nil
	}

	func test_secureUserSettings_setPinCode() {
		
		// Given
		expect(self.sut.pinCode) == nil
		
		// When
		sut.pinCode = "Testing"
		
		// Then
		expect(self.sut.pinCode) == "Testing"
	}
	
	func test_secureUserSettings_setTempPinCode() {
		
		// Given
		expect(self.sut.tempPinCode) == nil
		
		// When
		sut.tempPinCode = "Testing"
		
		// Then
		expect(self.sut.tempPinCode) == "Testing"
	}
	
	func test_secureUserSettings_setBioMetricAuthenticationEnabled() {
		
		// Given
		expect(self.sut.bioMetricAuthenticationEnabled) == false
		
		// When
		sut.bioMetricAuthenticationEnabled = true
		
		// Then
		expect(self.sut.bioMetricAuthenticationEnabled) == true
	}
	
	func test_secureUserSettings_setUserHasRemoteAuthentication() {
		
		// Given
		expect(self.sut.userHasRemoteAuthentication) == false
		
		// When
		sut.userHasRemoteAuthentication = true
		
		// Then
		expect(self.sut.userHasRemoteAuthentication) == true
	}
	
	func test_secureUserSettings_setUserHasSeenAppIntroduction() {
		
		// Given
		expect(self.sut.userHasSeenAppIntroduction) == false
		
		// When
		sut.userHasSeenAppIntroduction = true
		
		// Then
		expect(self.sut.userHasSeenAppIntroduction) == true
	}
	
	func test_secureUserSettings_setUserHasSeenJailBreakWarning() {
		
		// Given
		expect(self.sut.userHasSeenJailBreakWarning) == false
		
		// When
		sut.userHasSeenJailBreakWarning = true
		
		// Then
		expect(self.sut.userHasSeenJailBreakWarning) == true
	}
}
