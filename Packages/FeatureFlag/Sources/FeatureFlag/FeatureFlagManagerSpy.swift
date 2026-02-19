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
	
	public var invokedBypassRemoteAuthenticationSetter = false
	public var invokedBypassRemoteAuthenticationSetterCount = 0
	public var invokedBypassRemoteAuthentication: Bool?
	public var invokedBypassRemoteAuthenticationList = [Bool]()
	public var invokedBypassRemoteAuthenticationGetter = false
	public var invokedBypassRemoteAuthenticationGetterCount = 0
	public var stubbedBypassRemoteAuthentication: Bool! = false

	public var bypassRemoteAuthentication: Bool {
		set {
			invokedBypassRemoteAuthenticationSetter = true
			invokedBypassRemoteAuthenticationSetterCount += 1
			invokedBypassRemoteAuthentication = newValue
			invokedBypassRemoteAuthenticationList.append(newValue)
		}
		get {
			invokedBypassRemoteAuthenticationGetter = true
			invokedBypassRemoteAuthenticationGetterCount += 1
			return stubbedBypassRemoteAuthentication
		}
	}
}
