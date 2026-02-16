/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import UIKit
import MGOUI
import MGOFoundation
import FileStorage
import RijksoverheidFont

class AppDelegate: NSObject, UIApplicationDelegate {
	
	/// set orientations you want to be allowed in this property by default
	static var orientationLock = UIInterfaceOrientationMask.all
	
	/// Dependency injectable Local authentication provider
	@Injected(\.localAuthenticationProvider) private var localAuthenticationProvider
	
	/// Dependency injectable Secure User Settings
	@Injected(\.secureUserSettings) private var secureUserSettings
	
	/// Dependency injectable Feature Flag Manager
	@Injected(\.featureFlagManager) private var featureFlagManager
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		
		HTTPStubs.removeAllStubs()
		checkLaunchArguments()
		styleUI()
		
		clearDirectoryCache()
		
		if Configuration().getRelease() == .demo {
			featureFlagManager.isDemo = true
			featureFlagManager.isAutomaticLocalizationEnabled = true
		}
		
		return true
	}
	
	/// Remove previously generated PDF exports and downloaded files
	private func clearDirectoryCache() {
		
		FileStorage().remove(HealthDirectory.binary)
		FileStorage().remove(HealthDirectory.export)
	}
	
	@MainActor
	private func styleUI() {
		
		// Set fonts for the Navigation bar
		UINavigationBar.appearance().titleTextAttributes = [
			.foregroundColor: UIColor(Theme().labels.primary),
			.font: UIFont.rijksoverheidFont(
				.bold,
				size: Font.TextStyle.body.pointSize
			) as Any
		]
		UINavigationBar.appearance().largeTitleTextAttributes = [
			.foregroundColor: UIColor(Theme().labels.primary),
			.font: UIFont.rijksoverheidFont(
				.bold,
				size: Font.TextStyle.largeTitle.pointSize
			) as Any
		]
		
		// Make the titles fit.
		UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
		UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).minimumScaleFactor = 0.80
	}
	
	private func checkLaunchArguments() {
		
		if LaunchArgumentsHandler.shouldDisableTransitions() {
			// Disable UIView animations for UI testing
			UIView.setAnimationsEnabled(false)
		}
		
		if LaunchArgumentsHandler.shouldResetOnStart() {
			// Wipe all data
			Container.shared.wipePersistedData()
			// Reset Featureflag settings
			featureFlagManager.wipePersistedData()
		}
		
		if LaunchArgumentsHandler.shouldShowUpdateRequired() {
			// Stub the remote config call
			stub(condition: isHost("app-api.test.mgo.irealisatie.nl")) { _ in
				return HTTPStubsResponse(jsonObject: ["iosMinimumVersion": "99999"], statusCode: 200, headers: nil)
			}
		}
		if let pincode = LaunchArgumentsHandler.withPincode() {
			secureUserSettings.pinCode = pincode
		}
		if LaunchArgumentsHandler.hasRemoteAuthentication() {
			secureUserSettings.userHasRemoteAuthentication = true
		}
		if LaunchArgumentsHandler.shouldEnableFaceID() {
			localAuthenticationProvider.biometricType = { .faceID }
		}
		if LaunchArgumentsHandler.isAutomaticLocalizationEnabled() {
			featureFlagManager.isAutomaticLocalizationEnabled = true
		}
		if LaunchArgumentsHandler.isDemo() {
			featureFlagManager.isDemo = true
		}
	}
	
	// MARK: End of life
	
	func applicationWillTerminate(_ application: UIApplication) {
		clearDirectoryCache()
	}
	
	// MARK: Orientation
	
	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		return AppDelegate.orientationLock
	}
	
	// MARK: 3rd Party Keyboard
	
	func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
		
		// See https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623122-application
		return extensionPointIdentifier != .keyboard
	}
}
