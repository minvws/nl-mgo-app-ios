/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import UIKit
import MGOUI

class AppDelegate: NSObject, UIApplicationDelegate {
	
	/// set orientations you want to be allowed in this property by default
	static var orientationLock = UIInterfaceOrientationMask.all
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		
		if LaunchArgumentsHandler.shouldDisableTransitions() {
			// Disable UIView animations for UI testing
			UIView.setAnimationsEnabled(false)
		}
		
		styleUI()
		registerObservers()
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
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(onWillResignActiveNotification),
			name: UIApplication.willResignActiveNotification,
			object: nil
		)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(onDidBecomeActiveNotification),
			name: UIApplication.didBecomeActiveNotification,
			object: nil
		)
	}
	
	private enum Constants {
		static let privacyWindowAnimationDuration: TimeInterval = 0.15
	}
	
	/// Window that hosts the snapshot
	private var privacySnapshotWindow: UIWindow?
	
	/// Handle the event that the application will resign active notification
	@objc private func onWillResignActiveNotification() {
		
		if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
			privacySnapshotWindow = UIWindow(windowScene: windowScene)
			
			let shapshotViewController = UIHostingController(rootView: SnapshotView(showSpinner: .constant(false)))
			privacySnapshotWindow?.rootViewController = shapshotViewController
			// Present window above alert controllers
			privacySnapshotWindow?.windowLevel = .alert + 1
			privacySnapshotWindow?.alpha = 0
			privacySnapshotWindow?.makeKeyAndVisible()
			
			withAnimation {
				self.privacySnapshotWindow?.alpha = 1
			}
		}
	}
	
	/// Handle the event the application did become active
	@objc func onDidBecomeActiveNotification() {
		
		// Hide when app becomes active
		if #available(iOS 17.0, *) {
			withAnimation {
				self.privacySnapshotWindow?.alpha = 0
			} completion: {
				self.privacySnapshotWindow?.isHidden = true
				self.privacySnapshotWindow = nil
			}
		} else {
			withAnimation(.linear(duration: Constants.privacyWindowAnimationDuration)) {
				self.privacySnapshotWindow?.alpha = 0
			}
			delay(Constants.privacyWindowAnimationDuration) {
				self.privacySnapshotWindow?.isHidden = true
				self.privacySnapshotWindow = nil
			}
		}
	}
}
