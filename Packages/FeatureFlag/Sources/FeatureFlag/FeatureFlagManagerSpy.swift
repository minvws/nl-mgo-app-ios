/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public class FeatureFlagManagerSpy: FeatureFlagManaging {

	public init() { /* Public initializer needed for public access */ }

	public var invokedIsAutomaticLocalizationEnabledSetter = false
	public var invokedIsAutomaticLocalizationEnabledSetterCount = 0
	public var invokedIsAutomaticLocalizationEnabled: Bool?
	public var invokedIsAutomaticLocalizationEnabledList = [Bool]()
	public var invokedIsAutomaticLocalizationEnabledGetter = false
	public var invokedIsAutomaticLocalizationEnabledGetterCount = 0
	public var stubbedIsAutomaticLocalizationEnabled: Bool! = false

	public var isAutomaticLocalizationEnabled: Bool {
		set {
			invokedIsAutomaticLocalizationEnabledSetter = true
			invokedIsAutomaticLocalizationEnabledSetterCount += 1
			invokedIsAutomaticLocalizationEnabled = newValue
			invokedIsAutomaticLocalizationEnabledList.append(newValue)
		}
		get {
			invokedIsAutomaticLocalizationEnabledGetter = true
			invokedIsAutomaticLocalizationEnabledGetterCount += 1
			return stubbedIsAutomaticLocalizationEnabled
		}
	}

	public var invokedIsDemoSetter = false
	public var invokedIsDemoSetterCount = 0
	public var invokedIsDemo: Bool?
	public var invokedIsDemoList = [Bool]()
	public var invokedIsDemoGetter = false
	public var invokedIsDemoGetterCount = 0
	public var stubbedIsDemo: Bool! = false

	public var isDemo: Bool {
		set {
			invokedIsDemoSetter = true
			invokedIsDemoSetterCount += 1
			invokedIsDemo = newValue
			invokedIsDemoList.append(newValue)
		}
		get {
			invokedIsDemoGetter = true
			invokedIsDemoGetterCount += 1
			return stubbedIsDemo
		}
	}

	public var invokedWipePersistedData = false
	public var invokedWipePersistedDataCount = 0

	public func wipePersistedData() {
		invokedWipePersistedData = true
		invokedWipePersistedDataCount += 1
	}
	
	public var invokedBypassPincodeSetter = false
	public var invokedBypassPincodeSetterCount = 0
	public var invokedBypassPincode: Bool?
	public var invokedBypassPincodeList = [Bool]()
	public var invokedBypassPincodeGetter = false
	public var invokedBypassPincodeGetterCount = 0
	public var stubbedBypassPincode: Bool! = false

	public var bypassPincode: Bool {
		set {
			invokedBypassPincodeSetter = true
			invokedBypassPincodeSetterCount += 1
			invokedBypassPincode = newValue
			invokedBypassPincodeList.append(newValue)
		}
		get {
			invokedBypassPincodeGetter = true
			invokedBypassPincodeGetterCount += 1
			return stubbedBypassPincode
		}
	}
}
