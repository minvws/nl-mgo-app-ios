/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import UIKit
import MGOUI
import MGOFoundation
import FileStorage

class AppDelegate: NSObject, UIApplicationDelegate {
	
	/// set orientations you want to be allowed in this property by default
	static var orientationLock = UIInterfaceOrientationMask.all
	
	/// Dependency injectable Local authentication provider
	@Injected(\.localAuthenticationProvider) private var localAuthenticationProvider
	
	/// Dependency injectable Secure User Settings
	@Injected(\.secureUserSettings) private var secureUserSettings
	
	/// Dependency injectable Feature Flag Manager
	@Injected(\.featureFlagManager) private var featureFlagManager
	
	/// Dependency injectable Notification Center
	@Injected(\.notificationCenter) private var notificationCenter
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		
		HTTPStubs.removeAllStubs()
		checkLaunchArguments()
		styleUI()
		registerObservers()
		
		// Reset the background timestamp
		secureUserSettings.enteredBackground = nil
		
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
	
	private func styleUI() {
		
		// Set fonts for the Navigation bar
		UINavigationBar.appearance().titleTextAttributes = [
			.foregroundColor: UIColor(Theme().labels.primary),
			.font: UIFont(
				name: RijksoverheidSansWebTextFont.bold.fontName,
				size: Font.TextStyle.body.pointSize
			) as Any
		]
		UINavigationBar.appearance().largeTitleTextAttributes = [
			.foregroundColor: UIColor(Theme().labels.primary),
			.font: UIFont(
				name: RijksoverheidSansWebTextFont.bold.fontName,
				size: Font.TextStyle.title.pointSize
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
	
	// MARK: - Privacy Snapshot -

	private func registerObservers() {
		
		// Back and foreground
		
		notificationCenter.addObserver(
			self,
			selector: #selector(onWillResignActiveNotification),
			name: UIApplication.willResignActiveNotification,
			object: nil
		)
		notificationCenter.addObserver(
			self,
			selector: #selector(onDidBecomeActiveNotification),
			name: UIApplication.didBecomeActiveNotification,
			object: nil
		)
	}
	
	// MARK: - Privacy Snapshot -
	
	/// Window that hosts the snapshot
	internal var privacySnapshotWindow: UIWindow?
	
	/// The privacy view
	internal let privacyView = UIHostingController(rootView: SnapshotView(showSpinner: .constant(false)))
	
	/// How many seconds must we be in the background before we show the local authentication view upon reentry?
	internal let localAuthenticationTimeOut: TimeInterval = 120

	/// Handle the event that the application will resign active notification
	@objc func onWillResignActiveNotification() {
		
		if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
			privacySnapshotWindow = UIWindow(windowScene: windowScene)
			
			privacySnapshotWindow?.rootViewController = privacyView
			// Present window above alert controllers
			privacySnapshotWindow?.windowLevel = .alert + 2
			privacySnapshotWindow?.alpha = 0
			privacySnapshotWindow?.makeKeyAndVisible()
			
			withAnimation {
				self.privacySnapshotWindow?.alpha = 1
			}
			// Mark the date
			guard secureUserSettings.enteredBackground == nil else { return }
			let timeStamp = Container.shared.now()()
			secureUserSettings.enteredBackground = timeStamp
			logWarning("Entered background at", timeStamp)
		}
	}
	
	/// Handle the event the application did become active
	@objc func onDidBecomeActiveNotification() {

		// Animation in iOS 16 can cause transition errors when switching repeatedly very fast.
		self.privacySnapshotWindow?.alpha = 0
		self.privacySnapshotWindow?.isHidden = true
		self.privacySnapshotWindow = nil
		
		// Check the timestamp we entered the background.
		guard let enteredBackground = secureUserSettings.enteredBackground else { return }
		if Date().timeIntervalSince(enteredBackground) >= localAuthenticationTimeOut {
			logWarning("We are in the background longer then \(localAuthenticationTimeOut) seconds. Post show Local Authentication")
			notificationCenter.post(name: .showLocalAuthentication, object: nil)
		} else {
			logVerbose("We returned in time, reset enteredBackground to nil.")
			secureUserSettings.enteredBackground = nil
		}
	}
}
