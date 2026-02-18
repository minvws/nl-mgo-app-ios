/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// Protocol for the secure user settings
public protocol SecureUserSettingsProtocol: AnyObject {
	
	/// Have we seen the jail break warning?
	var userHasSeenJailBreakWarning: Bool { get set }
	
	/// Is the user a first time vistor
	var firstTimeVisitor: Bool { get set }
	
	/// Wipe all persisted data
	func wipePersistedData()
}

/// The class that holds all the secure user settings
public class SecureUserSettings: SecureUserSettingsProtocol {
	
	/// Default values
	public struct Defaults {
		public static let userHasSeenJailBreakWarning: Bool = false
		public static let firstTimeVisitor: Bool = true
	}
	
	/// Create the secure user settings
	public init() { /* Public initializer needed for public access */ }
	
	@Keychain(name: "userHasSeenJailBreakWarning", service: "Security" + SecureUserSettings.serviceExtension, clearOnReinstall: true)
	public var userHasSeenJailBreakWarning: Bool = Defaults.userHasSeenJailBreakWarning
	
	@Keychain(name: "firstTimeVisitor", service: "AppIntroduction" + SecureUserSettings.serviceExtension, clearOnReinstall: true)
	public var firstTimeVisitor: Bool = Defaults.firstTimeVisitor
		
	/// Helper method to detect if we are unit testing.
	/// If so, append `_test` to the service name to separate tests from production
	static private var serviceExtension: String {
		guard NSClassFromString("XCTestCase") != nil else {
			return ""
		}
		return "_test"
	}
}

extension SecureUserSettings {
	
	/// Wipe all persisted data
	public func wipePersistedData() {
		userHasSeenJailBreakWarning = Defaults.userHasSeenJailBreakWarning
		firstTimeVisitor = Defaults.firstTimeVisitor
	}
}
