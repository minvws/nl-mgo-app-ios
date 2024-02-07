/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

class SecureUserSettingsSpy: SecureUserSettingsProtocol {
	
	var invokedUserHasSeenAppIntroductionSetter = false
	var invokedUserHasSeenAppIntroductionSetterCount = 0
	var invokedUserHasSeenAppIntroduction: Bool?
	var invokedUserHasSeenAppIntroductionList = [Bool]()
	var invokedUserHasSeenAppIntroductionGetter = false
	var invokedUserHasSeenAppIntroductionGetterCount = 0
	var stubbedUserHasSeenAppIntroduction: Bool! = false
	
	var userHasSeenAppIntroduction: Bool {
		set {
			invokedUserHasSeenAppIntroductionSetter = true
			invokedUserHasSeenAppIntroductionSetterCount += 1
			invokedUserHasSeenAppIntroduction = newValue
			invokedUserHasSeenAppIntroductionList.append(newValue)
		}
		get {
			invokedUserHasSeenAppIntroductionGetter = true
			invokedUserHasSeenAppIntroductionGetterCount += 1
			return stubbedUserHasSeenAppIntroduction
		}
	}
	
	var invokedWipePersistedData = false
	var invokedWipePersistedDataCount = 0
	
	func wipePersistedData() {
		invokedWipePersistedData = true
		invokedWipePersistedDataCount += 1
	}
}
