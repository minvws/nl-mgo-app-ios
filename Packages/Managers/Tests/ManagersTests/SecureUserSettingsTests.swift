/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest
import Nimble
@testable import Managers

final class SecureUserSettingsTests: XCTestCase {

	func test_secureUserSettings_readUserHasSeenAppIntroduction() {
		
		// Given
		let sut = SecureUserSettings()
		
		// When
		sut.wipePersistedData()
		
		// Then
		expect(sut.userHasSeenAppIntroduction) == false
	}
	
	func test_secureUserSettings_setUserHasSeenAppIntroduction() {
		
		// Given
		let sut = SecureUserSettings()
		
		// When
		sut.userHasSeenAppIntroduction = true
		
		// Then
		expect(sut.userHasSeenAppIntroduction) == true
	}
}
