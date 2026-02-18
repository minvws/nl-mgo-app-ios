/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public class SecureUserSettingsSpy: SecureUserSettingsProtocol {
	
	/// Initlializer
	public init() { /* Public initializer needed for public access */ }

	public var invokedUserHasSeenJailBreakWarningSetter = false
	public var invokedUserHasSeenJailBreakWarningSetterCount = 0
	public var invokedUserHasSeenJailBreakWarning: Bool?
	public var invokedUserHasSeenJailBreakWarningList = [Bool]()
	public var invokedUserHasSeenJailBreakWarningGetter = false
	public var invokedUserHasSeenJailBreakWarningGetterCount = 0
	public var stubbedUserHasSeenJailBreakWarning: Bool! = false

	public var userHasSeenJailBreakWarning: Bool {
		set {
			invokedUserHasSeenJailBreakWarningSetter = true
			invokedUserHasSeenJailBreakWarningSetterCount += 1
			invokedUserHasSeenJailBreakWarning = newValue
			invokedUserHasSeenJailBreakWarningList.append(newValue)
		}
		get {
			invokedUserHasSeenJailBreakWarningGetter = true
			invokedUserHasSeenJailBreakWarningGetterCount += 1
			return stubbedUserHasSeenJailBreakWarning
		}
	}

	public var invokedFirstTimeVisitorSetter = false
	public var invokedFirstTimeVisitorSetterCount = 0
	public var invokedFirstTimeVisitor: Bool?
	public var invokedFirstTimeVisitorList = [Bool]()
	public var invokedFirstTimeVisitorGetter = false
	public var invokedFirstTimeVisitorGetterCount = 0
	public var stubbedFirstTimeVisitor: Bool! = true

	public var firstTimeVisitor: Bool {
		set {
			invokedFirstTimeVisitorSetter = true
			invokedFirstTimeVisitorSetterCount += 1
			invokedFirstTimeVisitor = newValue
			invokedFirstTimeVisitorList.append(newValue)
		}
		get {
			invokedFirstTimeVisitorGetter = true
			invokedFirstTimeVisitorGetterCount += 1
			return stubbedFirstTimeVisitor
		}
	}

	public var invokedWipePersistedData = false
	public var invokedWipePersistedDataCount = 0

	public func wipePersistedData() {
		invokedWipePersistedData = true
		invokedWipePersistedDataCount += 1
	}
}
