/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public extension UserDefaults {
	
	enum Keys: String {
		case isAutomaticLocalizationEnabled
	}
}

public protocol FeatureFlagManaging {
	
	/// Do we use automatic localization?
	var isAutomaticLocalizationEnabled: Bool { get set }
	
	var isDemo: Bool { get }
	
	func wipePersistedData()
}

public class FeatureFlagManager: FeatureFlagManaging {
	
	public init() {
		// Public initializer
	}
	
	/// Do we use automatic localization?
	@UserDefault(key: UserDefaults.Keys.isAutomaticLocalizationEnabled.rawValue + (ProcessInfo.processInfo.arguments.contains("--unittesting") ? ".test" : ""), defaultValue: true)
	public var isAutomaticLocalizationEnabled: Bool
	
	public var isDemo: Bool = false
	
	/// Remove all the feature flags and reset to default
	public func wipePersistedData() {
		isAutomaticLocalizationEnabled = true
	}
}
