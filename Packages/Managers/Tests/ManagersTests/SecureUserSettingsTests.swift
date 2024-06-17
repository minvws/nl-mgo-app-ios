/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import Managers

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
		sut.userHasAddedHealthcareProvider = true
		sut.userHasRemoteAuthentication = true
		sut.bioMetricAuthenticationEnabled = true
		sut.accessCode = "TEST"
		
		// When
		sut.wipePersistedData()
		
		// Then
		expect(self.sut.userHasSeenAppIntroduction) == false
		expect(self.sut.userHasAddedHealthcareProvider) == false
		expect(self.sut.userHasRemoteAuthentication) == false
		expect(self.sut.bioMetricAuthenticationEnabled) == false
		expect(self.sut.accessCode) == nil
	}

	func test_secureUserSettings_setAccessCode() {
		
		// Given
		expect(self.sut.accessCode) == nil
		
		// When
		sut.accessCode = "Testing"
		
		// Then
		expect(self.sut.accessCode) == "Testing"
	}
	
	func test_secureUserSettings_setBioMetricAuthenticationEnabled() {
		
		// Given
		expect(self.sut.bioMetricAuthenticationEnabled) == false
		
		// When
		sut.bioMetricAuthenticationEnabled = true
		
		// Then
		expect(self.sut.bioMetricAuthenticationEnabled) == true
	}
	
	func test_secureUserSettings_setUserHasSeenAppIntroduction() {
		
		// Given
		expect(self.sut.userHasSeenAppIntroduction) == false
		
		// When
		sut.userHasSeenAppIntroduction = true
		
		// Then
		expect(self.sut.userHasSeenAppIntroduction) == true
	}
	
	func test_secureUserSettings_userHasAddedHealthcareProvider() {
		
		// Given
		expect(self.sut.userHasAddedHealthcareProvider) == false
		
		// When
		sut.userHasAddedHealthcareProvider = true
		
		// Then
		expect(self.sut.userHasAddedHealthcareProvider) == true
	}
	
	func test_secureUserSettings_setUserHasRemoteAuthentication() {
		
		// Given
		expect(self.sut.userHasRemoteAuthentication) == false
		
		// When
		sut.userHasRemoteAuthentication = true
		
		// Then
		expect(self.sut.userHasRemoteAuthentication) == true
	}
}
