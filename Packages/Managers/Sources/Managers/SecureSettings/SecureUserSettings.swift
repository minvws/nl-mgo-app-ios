/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// Protocol for the secure user settings
public protocol SecureUserSettingsProtocol: AnyObject {
	
	/// the first entry of the access code
	var tempAccessCode: String? { get set }
	
	/// the access code
	var accessCode: String? { get set }
	
	/// Do we have setup the biomtetric authentication
	var bioMetricAuthenticationEnabled: Bool { get set }
	
	/// Have we seen the app introduction
	var userHasSeenAppIntroduction: Bool { get set }
	
	/// Did the user complete the DigiD flow?
	var userHasRemoteAuthentication: Bool { get set }
	
	/// Wipe all persisted data
	func wipePersistedData()
}

/// The class that holds all the secure usser settings
public class SecureUserSettings: SecureUserSettingsProtocol {
	
	/// Default values
	public struct Defaults {
		public static var userHasSeenAppIntroduction: Bool = false
		public static var userHasRemoteAuthentication: Bool = false
		public static var bioMetricAuthenticationEnabled: Bool = false
		public static var accessCode: String?
	}
	
	/// Initializer
	public init() {}
	
	@Keychain(name: "userHasSeenAppIntroduction", service: "AppIntroduction" + SecureUserSettings.serviceExtension, clearOnReinstall: true)
	public var userHasSeenAppIntroduction: Bool = Defaults.userHasSeenAppIntroduction
	
	@Keychain(name: "accessCode", service: "AppIntroduction" + SecureUserSettings.serviceExtension, clearOnReinstall: true)
	public var accessCode: String? = Defaults.accessCode
	
	@Keychain(name: "bioMetricAuthenticationEnabled", service: "AppIntroduction" + SecureUserSettings.serviceExtension, clearOnReinstall: true)
	public var bioMetricAuthenticationEnabled: Bool = Defaults.bioMetricAuthenticationEnabled

	@Keychain(name: "tempAccessCode", service: "AppIntroduction" + SecureUserSettings.serviceExtension, clearOnReinstall: true)
	public var tempAccessCode: String? = Defaults.accessCode
	
	@Keychain(name: "userHasRemoteAuthentication", service: "AppIntroduction" + SecureUserSettings.serviceExtension, clearOnReinstall: true)
	public var userHasRemoteAuthentication: Bool = Defaults.userHasRemoteAuthentication
	
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
		accessCode = Defaults.accessCode
		bioMetricAuthenticationEnabled = Defaults.bioMetricAuthenticationEnabled
		tempAccessCode = Defaults.accessCode
		userHasSeenAppIntroduction = Defaults.userHasSeenAppIntroduction
		userHasRemoteAuthentication = Defaults.userHasRemoteAuthentication
	}
}
