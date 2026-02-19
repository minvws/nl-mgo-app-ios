/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

@main
struct MainEntryPoint {
	
	static func main() {
		
		guard isProduction() else {
			TestApp.main()
			return
		}
		ProductionApp.main()
	}
	
	private static func isProduction() -> Bool {
		return NSClassFromString("XCTestCase") == nil
	}
}

struct ProductionApp: App {
	
	/// The application delegate for lifecycle events
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
	/// The application appearance for light / dark / system mode
	@AppStorage("AppAppearance") private var selectedAppearance: AppAppearance = .system
	
	/// Which scene phase is the app?
	@Environment(\.scenePhase) private var phase
	
	/// Dependency injectable Secure User Settings
	@Injected(\.secureUserSettings) private var secureUserSettings
	
	/// Dependency injectable Notification Center
	@Injected(\.notificationCenter) private var notificationCenter
	
	/// The application coordinator to determine what view to show
	private var coordinator: AppCoordinator
	
	/// How many seconds must we be in the background before we show the local authentication view upon reentry?
	internal let localAuthenticationTimeOut: TimeInterval = 120
	
	/// Create the production app
	init() {
		coordinator = AppCoordinator(path: NavigationStackBackport.NavigationPath())
	}
	
	/// Show the privacy scene
	@State private var showPrivacyScene: Bool = false
	
	var body: some Scene {
		WindowGroup {
			ZStack {
				GeometryReader { geo in
					AppCoordinatorView<AppCoordinator>(appCoordinator: coordinator)
						.environment(\.safeAreaInsets, geo.safeAreaInsets)
						.preferredColorScheme(selectedAppearance.colorScheme)
				}
				
				SnapshotView(showSpinner: .constant(false))
					.opacity(showPrivacyScene ? 1 : 0)
			}
		}
		.onChange(of: phase) { newPhase in
			switch newPhase {
				case .active:
					becomesActive()
					
				case .inactive, .background:
					becomesInactive()
					
				default:
					break
			}
		}
	}
	
	/// Handle the app when we become inactive (i.e. show privacy scene)
	private func becomesInactive() {
		showPrivacyScene = true
	}
	
	/// Handle the app when we become active (again).
	private func becomesActive() {
		showPrivacyScene = false
	}
}

struct TestApp: App {
	
	init() {
		
		// Only run tests on a iPhone 17 Pro (screenshot dimensions will differ on other devices)
		let device = UIDevice.current.name
		if device != "iPhone 17 Pro" {
			fatalError("Switch to using iPhone 17 Pro for these tests.")
		}
		
		// Speedup animation
		UIView.setAnimationsEnabled(false)
		UIApplication
			.shared
			.connectedScenes
			.compactMap { ($0 as? UIWindowScene)?.keyWindow }
			.last?
			.layer
			.speed = 100
	}
	
	var body: some Scene {
		WindowGroup {
			// Nothing for the test app
			// See https://qualitycoding.org/bypass-swiftui-app-launch-unit-testing/
		}
	}
}
