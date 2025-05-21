/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public extension UserDefaults {
	
	enum Keys: String {
		case isAutomaticLocalizationEnabled
		case bypassPincode
	}
}

public protocol FeatureFlagManaging {
	
	/// Do we use automatic localization?
	var isAutomaticLocalizationEnabled: Bool { get set }
	
	/// Should we bypass the pincode login?
	var bypassPincode: Bool { get set }
	
	/// Are we running in demo mode?
	var isDemo: Bool { get set }
	
	/// Remove all the feature flags and reset to default
	func wipePersistedData()
}

public class FeatureFlagManager: FeatureFlagManaging {
	
	public init() {
		// Public initializer
	}
	
	/// Do we use automatic localization?
	@UserDefault(key: UserDefaults.Keys.isAutomaticLocalizationEnabled.rawValue + (ProcessInfo.processInfo.arguments.contains("--unittesting") ? ".test" : ""), defaultValue: false)
	public var isAutomaticLocalizationEnabled: Bool
	
	/// Should we bypass the pincode login?
	@UserDefault(key: UserDefaults.Keys.bypassPincode.rawValue + (ProcessInfo.processInfo.arguments.contains("--unittesting") ? ".test" : ""), defaultValue: false)
	public var bypassPincode: Bool
	
	/// Are we running in demo mode?
	public var isDemo: Bool = false
	
	/// Remove all the feature flags and reset to default
	public func wipePersistedData() {
		isAutomaticLocalizationEnabled = false
		bypassPincode = false
	}
}
