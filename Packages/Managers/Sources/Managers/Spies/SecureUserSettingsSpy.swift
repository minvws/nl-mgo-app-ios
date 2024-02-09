/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public class SecureUserSettingsSpy: SecureUserSettingsProtocol {
	
	public init() { }
	
	public var invokedUserHasSeenAppIntroductionSetter = false
	public var invokedUserHasSeenAppIntroductionSetterCount = 0
	public var invokedUserHasSeenAppIntroduction: Bool?
	public var invokedUserHasSeenAppIntroductionList = [Bool]()
	public var invokedUserHasSeenAppIntroductionGetter = false
	public var invokedUserHasSeenAppIntroductionGetterCount = 0
	public var stubbedUserHasSeenAppIntroduction: Bool! = false
	
	public var userHasSeenAppIntroduction: Bool {
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
	
	public var invokedWipePersistedData = false
	public var invokedWipePersistedDataCount = 0
	
	public func wipePersistedData() {
		invokedWipePersistedData = true
		invokedWipePersistedDataCount += 1
	}
}
