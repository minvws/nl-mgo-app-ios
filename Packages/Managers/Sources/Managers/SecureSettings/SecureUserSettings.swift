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
	var tempPinCode: String? { get set }
	
	/// the access code
	var pinCode: String? { get set }
	
	/// Do we have setup the biometric authentication
	var bioMetricAuthenticationEnabled: Bool { get set }
	
	/// Have we added a healthcare provider
	var userHasAddedHealthcareProvider: Bool { get set }

	/// Have we seen the app introduction
	var userHasSeenAppIntroduction: Bool { get set }
	
	/// Did the user complete the DigiD flow?
	var userHasRemoteAuthentication: Bool { get set }
	
	/// Wipe all persisted data
	func wipePersistedData()
}

/// The class that holds all the secure user settings
public class SecureUserSettings: SecureUserSettingsProtocol {
	
	/// Default values
	public struct Defaults {
		public static var userHasAddedHealthcareProvider: Bool = false
		public static var userHasSeenAppIntroduction: Bool = false
		public static var userHasRemoteAuthentication: Bool = false
		public static var bioMetricAuthenticationEnabled: Bool = false
		public static var pinCode: String?
	}
	
	/// Initlializer
	public init() {
		// Public initializer needed for public access.
	}
	
	@Keychain(name: "userHasAddedHealthcareProvider", service: "AppIntroduction" + SecureUserSettings.serviceExtension, clearOnReinstall: true)
	public var userHasAddedHealthcareProvider: Bool = Defaults.userHasAddedHealthcareProvider
	
	@Keychain(name: "userHasSeenAppIntroduction", service: "AppIntroduction" + SecureUserSettings.serviceExtension, clearOnReinstall: true)
	public var userHasSeenAppIntroduction: Bool = Defaults.userHasSeenAppIntroduction
	
	@Keychain(name: "accessCode", service: "AppIntroduction" + SecureUserSettings.serviceExtension, clearOnReinstall: true)
	public var pinCode: String? = Defaults.pinCode
	
	@Keychain(name: "bioMetricAuthenticationEnabled", service: "AppIntroduction" + SecureUserSettings.serviceExtension, clearOnReinstall: true)
	public var bioMetricAuthenticationEnabled: Bool = Defaults.bioMetricAuthenticationEnabled

	@Keychain(name: "tempPinCode", service: "LocalAuthentication" + SecureUserSettings.serviceExtension, clearOnReinstall: true)
	public var tempPinCode: String? = Defaults.pinCode
	
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
		pinCode = Defaults.pinCode
		bioMetricAuthenticationEnabled = Defaults.bioMetricAuthenticationEnabled
		tempPinCode = Defaults.pinCode
		userHasAddedHealthcareProvider = Defaults.userHasAddedHealthcareProvider
		userHasSeenAppIntroduction = Defaults.userHasSeenAppIntroduction
		userHasRemoteAuthentication = Defaults.userHasRemoteAuthentication
	}
}
