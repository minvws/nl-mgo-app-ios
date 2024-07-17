/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import UIKit
import MGOUI
import MGOFoundation

class AppDelegate: NSObject, UIApplicationDelegate {
	
	/// set orientations you want to be allowed in this property by default
	static var orientationLock = UIInterfaceOrientationMask.all
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		
		HTTPStubs.removeAllStubs()
		checkLaunchArguments()
		styleUI()
		return true
	}
	
	private func styleUI() {
		
		// No bouncy scrollview
		UIScrollView.appearance().bounces = false
		
		// Navigation bar
		let appearance = UINavigationBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = UIColor(Theme().backgroundPrimary)
		appearance.shadowColor = .clear
		UINavigationBar.appearance().standardAppearance = appearance
		UINavigationBar.appearance().compactAppearance = appearance
		UINavigationBar.appearance().scrollEdgeAppearance = appearance
	}
	
	private func checkLaunchArguments() {
		
		if LaunchArgumentsHandler.shouldDisableTransitions() {
			// Disable UIView animations for UI testing
			UIView.setAnimationsEnabled(false)
		}
		
		if LaunchArgumentsHandler.shouldResetOnStart() {
			// Wipe all data
			Current.wipePersistedData()
		}
		
		if LaunchArgumentsHandler.shouldShowUpdateRequired() {
			// Stub the remote config call
			stub(condition: isHost("app-api.test.mgo.irealisatie.nl")) { _ in
				return HTTPStubsResponse(jsonObject: ["iosMinimumVersion": "99999"], statusCode: 200, headers: nil)
			}
		}
		if LaunchArgumentsHandler.shouldSkipOnboarding() {
			Current.secureUserSettings.userHasSeenAppIntroduction = true
		}
		if let pincode = LaunchArgumentsHandler.hasPincode() {
			Current.secureUserSettings.pinCode = pincode
		}
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
