/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public extension UserDefaults {

	enum Keys: String {
		case bypassRemoteAuthentication
	}
}

public protocol FeatureFlagManaging: Sendable {

	/// Should we bypass the remote login?
	@MainActor var bypassRemoteAuthentication: Bool { get set }
	
	/// Remove all the feature flags and reset to default
	@MainActor func wipePersistedData()
}

@MainActor
public class FeatureFlagManager: FeatureFlagManaging, @unchecked Sendable {
	
	public init() {
		// Public initializer
	}
	
	/// Should we bypass the remote login?
	@UserDefault(key: UserDefaults.Keys.bypassRemoteAuthentication.rawValue + (ProcessInfo.processInfo.arguments.contains("--unittesting") ? ".test" : ""), defaultValue: false)
	@MainActor public var bypassRemoteAuthentication: Bool
	
	/// Remove all the feature flags and reset to default
	@MainActor public func wipePersistedData() {
		bypassRemoteAuthentication = false
	}
}
