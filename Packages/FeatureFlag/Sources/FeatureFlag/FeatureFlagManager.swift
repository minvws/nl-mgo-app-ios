/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
	
	var isDemo: Bool { get set }
	
	func wipePersistedData()
}

public class FeatureFlagManager: FeatureFlagManaging {
	
	public init() {
		// Public initializer
	}
	
	/// Do we use automatic localization?
	@UserDefault(key: UserDefaults.Keys.isAutomaticLocalizationEnabled.rawValue + (ProcessInfo.processInfo.arguments.contains("--unittesting") ? ".test" : ""), defaultValue: false)
	public var isAutomaticLocalizationEnabled: Bool
	
	public var isDemo: Bool = false
	
	/// Remove all the feature flags and reset to default
	public func wipePersistedData() {
		// Do not reset automatic localization, it is a dev only feature
	}
}
