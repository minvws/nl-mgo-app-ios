/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// Protocol for the secure user settings
public protocol SecureUserSettingsProtocol: AnyObject {
	
	/// Have we seen the app introduction
	var userHasSeenAppIntroduction: Bool { get set }
	
	/// Wipe all persisted data
	func wipePersistedData()
}

/// The class that holds all the secure usser settings
public class SecureUserSettings: SecureUserSettingsProtocol {
	
	/// Default values
	public struct Defaults {
		public static var userHasSeenAppIntroduction: Bool = false
	}
	
	/// Initializer
	public init() {}
	
	@Keychain(name: "userHasSeenAppIntroduction", service: "AppIntroduction" + SecureUserSettings.serviceExtension, clearOnReinstall: true)
	public var userHasSeenAppIntroduction: Bool = Defaults.userHasSeenAppIntroduction
	
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
		userHasSeenAppIntroduction = Defaults.userHasSeenAppIntroduction
	}
}
