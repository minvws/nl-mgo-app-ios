/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public class SecureUserSettingsSpy: SecureUserSettingsProtocol {

	/// Initlializer
	public init() { /* Public initializer needed for public access */ }
	
	public var invokedTempPinCodeSetter = false
	public var invokedTempPinCodeSetterCount = 0
	public var invokedTempPinCode: String?
	public var invokedTempPinCodeList = [String?]()
	public var invokedTempPinCodeGetter = false
	public var invokedTempPinCodeGetterCount = 0
	public var stubbedTempPinCode: String!

	public var tempPinCode: String? {
		set {
			invokedTempPinCodeSetter = true
			invokedTempPinCodeSetterCount += 1
			invokedTempPinCode = newValue
			invokedTempPinCodeList.append(newValue)
		}
		get {
			invokedTempPinCodeGetter = true
			invokedTempPinCodeGetterCount += 1
			return stubbedTempPinCode
		}
	}

	public var invokedPinCodeSetter = false
	public var invokedPinCodeSetterCount = 0
	public var invokedPinCode: String?
	public var invokedPinCodeList = [String?]()
	public var invokedPinCodeGetter = false
	public var invokedPinCodeGetterCount = 0
	public var stubbedPinCode: String!

	public var pinCode: String? {
		set {
			invokedPinCodeSetter = true
			invokedPinCodeSetterCount += 1
			invokedPinCode = newValue
			invokedPinCodeList.append(newValue)
		}
		get {
			invokedPinCodeGetter = true
			invokedPinCodeGetterCount += 1
			return stubbedPinCode
		}
	}

	public var invokedBioMetricAuthenticationEnabledSetter = false
	public var invokedBioMetricAuthenticationEnabledSetterCount = 0
	public var invokedBioMetricAuthenticationEnabled: Bool?
	public var invokedBioMetricAuthenticationEnabledList = [Bool]()
	public var invokedBioMetricAuthenticationEnabledGetter = false
	public var invokedBioMetricAuthenticationEnabledGetterCount = 0
	public var stubbedBioMetricAuthenticationEnabled: Bool! = false

	public var bioMetricAuthenticationEnabled: Bool {
		set {
			invokedBioMetricAuthenticationEnabledSetter = true
			invokedBioMetricAuthenticationEnabledSetterCount += 1
			invokedBioMetricAuthenticationEnabled = newValue
			invokedBioMetricAuthenticationEnabledList.append(newValue)
		}
		get {
			invokedBioMetricAuthenticationEnabledGetter = true
			invokedBioMetricAuthenticationEnabledGetterCount += 1
			return stubbedBioMetricAuthenticationEnabled
		}
	}
	
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

	public var invokedUserHasRemoteAuthenticationSetter = false
	public var invokedUserHasRemoteAuthenticationSetterCount = 0
	public var invokedUserHasRemoteAuthentication: Bool?
	public var invokedUserHasRemoteAuthenticationList = [Bool]()
	public var invokedUserHasRemoteAuthenticationGetter = false
	public var invokedUserHasRemoteAuthenticationGetterCount = 0
	public var stubbedUserHasRemoteAuthentication: Bool! = false

	public var userHasRemoteAuthentication: Bool {
		set {
			invokedUserHasRemoteAuthenticationSetter = true
			invokedUserHasRemoteAuthenticationSetterCount += 1
			invokedUserHasRemoteAuthentication = newValue
			invokedUserHasRemoteAuthenticationList.append(newValue)
		}
		get {
			invokedUserHasRemoteAuthenticationGetter = true
			invokedUserHasRemoteAuthenticationGetterCount += 1
			return stubbedUserHasRemoteAuthentication
		}
	}

	public var invokedWipePersistedData = false
	public var invokedWipePersistedDataCount = 0

	public func wipePersistedData() {
		invokedWipePersistedData = true
		invokedWipePersistedDataCount += 1
	}
	
	public var invokedEnteredBackgroundSetter = false
	public var invokedEnteredBackgroundSetterCount = 0
	public var invokedEnteredBackground: Date?
	public var invokedEnteredBackgroundList = [Date?]()
	public var invokedEnteredBackgroundGetter = false
	public var invokedEnteredBackgroundGetterCount = 0
	public var stubbedEnteredBackground: Date!

	public var enteredBackground: Date? {
		set {
			invokedEnteredBackgroundSetter = true
			invokedEnteredBackgroundSetterCount += 1
			invokedEnteredBackground = newValue
			invokedEnteredBackgroundList.append(newValue)
		}
		get {
			invokedEnteredBackgroundGetter = true
			invokedEnteredBackgroundGetterCount += 1
			return stubbedEnteredBackground
		}
	}
}
