/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public extension UserDefaults {
	
	enum Keys: String {
		case isAutomaticLocalizationEnabled
		case bypassRemoteAuthentication
	}
}

public protocol FeatureFlagManaging: Sendable {
	
	/// Do we use automatic localization?
	@MainActor var isAutomaticLocalizationEnabled: Bool { get set }
	
	/// Should we bypass the remote login?
	@MainActor var bypassRemoteAuthentication: Bool { get set }
	
	/// Are we running in demo mode?
	@MainActor var isDemo: Bool { get set }
	
	/// Remove all the feature flags and reset to default
	@MainActor func wipePersistedData()
}

@MainActor
public class FeatureFlagManager: FeatureFlagManaging, @unchecked Sendable {
	
	public init() {
		// Public initializer
	}
	
	/// Do we use automatic localization?
	@UserDefault(key: UserDefaults.Keys.isAutomaticLocalizationEnabled.rawValue + (ProcessInfo.processInfo.arguments.contains("--unittesting") ? ".test" : ""), defaultValue: false)
	@MainActor public var isAutomaticLocalizationEnabled: Bool
	
	/// Should we bypass the remote login?
	@UserDefault(key: UserDefaults.Keys.bypassRemoteAuthentication.rawValue + (ProcessInfo.processInfo.arguments.contains("--unittesting") ? ".test" : ""), defaultValue: false)
	@MainActor public var bypassRemoteAuthentication: Bool
	
	/// Are we running in demo mode?
	@MainActor public var isDemo: Bool = false
	
	/// Remove all the feature flags and reset to default
	@MainActor public func wipePersistedData() {
		isAutomaticLocalizationEnabled = false
		bypassRemoteAuthentication = false
	}
}
