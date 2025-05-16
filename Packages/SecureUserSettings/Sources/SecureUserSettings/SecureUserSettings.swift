/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// Protocol for the secure user settings
public protocol SecureUserSettingsProtocol: AnyObject {
	
	/// Timestamp the app went to the background
	var enteredBackground: Date? { get set }
	
	/// the first entry of the access code
	var tempPinCode: String? { get set }
	
	/// the access code
	var pinCode: String? { get set }
	
	/// Do we have setup the biometric authentication
	var bioMetricAuthenticationEnabled: Bool { get set }
	
	/// Have we seen the jail break warning?
	var userHasSeenJailBreakWarning: Bool { get set }
	
	/// Did the user complete the DigiD flow?
	var userHasRemoteAuthentication: Bool { get set }
	
	/// Wipe all persisted data
	func wipePersistedData()
}

/// The class that holds all the secure user settings
public class SecureUserSettings: SecureUserSettingsProtocol {
	
	/// Default values
	public struct Defaults {
		public static var enteredBackground: Date?
		public static var bioMetricAuthenticationEnabled: Bool = false
		public static var pinCode: String?
		public static var userHasSeenJailBreakWarning: Bool = false
		public static var userHasRemoteAuthentication: Bool = false
	}
	
	/// Create the secure user settings
	public init() { /* Public initializer needed for public access */ }
	
	@Keychain(name: "enteredBackground", service: "Security" + SecureUserSettings.serviceExtension, clearOnReinstall: false)
	public var enteredBackground: Date? = Defaults.enteredBackground
	
	@Keychain(name: "pinCode", service: "LocalAuthentication" + SecureUserSettings.serviceExtension, clearOnReinstall: true)
	public var pinCode: String? = Defaults.pinCode

	@Keychain(name: "bioMetricAuthenticationEnabled", service: "AppIntroduction" + SecureUserSettings.serviceExtension, clearOnReinstall: true)
	public var bioMetricAuthenticationEnabled: Bool = Defaults.bioMetricAuthenticationEnabled

	@Keychain(name: "tempPinCode", service: "LocalAuthentication" + SecureUserSettings.serviceExtension, clearOnReinstall: true)
	public var tempPinCode: String? = Defaults.pinCode

	@Keychain(name: "userHasRemoteAuthentication", service: "AppIntroduction" + SecureUserSettings.serviceExtension, clearOnReinstall: true)
	public var userHasRemoteAuthentication: Bool = Defaults.userHasRemoteAuthentication
	
	@Keychain(name: "userHasSeenJailBreakWarning", service: "Security" + SecureUserSettings.serviceExtension, clearOnReinstall: true)
	public var userHasSeenJailBreakWarning: Bool = Defaults.userHasSeenJailBreakWarning
		
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
		enteredBackground = Defaults.enteredBackground
		pinCode = Defaults.pinCode
		bioMetricAuthenticationEnabled = Defaults.bioMetricAuthenticationEnabled
		tempPinCode = Defaults.pinCode
		userHasRemoteAuthentication = Defaults.userHasRemoteAuthentication
		userHasSeenJailBreakWarning = Defaults.userHasSeenJailBreakWarning
	}
}
