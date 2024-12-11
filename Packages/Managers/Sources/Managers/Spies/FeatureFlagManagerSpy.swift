/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
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

	public var invokedIsDemoGetter = false
	public var invokedIsDemoGetterCount = 0
	public var stubbedIsDemo: Bool! = false
	
	public var isDemo: Bool {
		invokedIsDemoGetter = true
		invokedIsDemoGetterCount += 1
		return stubbedIsDemo
	}

	public var invokedWipePersistedData = false
	public var invokedWipePersistedDataCount = 0

	public func wipePersistedData() {
		invokedWipePersistedData = true
		invokedWipePersistedDataCount += 1
	}

}
