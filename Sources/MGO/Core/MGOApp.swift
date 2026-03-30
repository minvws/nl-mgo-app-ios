/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGODebug
import MGOUI
import MGOFoundation

/// The application entry point.
///
/// Performs pre-launch configuration (logging) and then delegates to either
/// `ProductionApp` or `TestApp` depending on whether XCTest is loaded.
@main
struct MainEntryPoint {
	
	/// Configures the app and launches the appropriate entry point.
	static func main() {
		configureLogging()
		
		guard isProduction() else {
			TestApp.main()
			return
		}
		ProductionApp.main()
	}
	
	/// Returns `true` when the app is running outside of a test host process.
	private static func isProduction() -> Bool {
		return NSClassFromString("XCTestCase") == nil
	}
	
	/// Reads `LOG_LEVEL` from the app's `Info.plist` and sets `SwiftLogger.level`.
	///
	/// The value is matched case-insensitively against the `LoggingLevel` case names
	/// (`verbose`, `debug`, `info`, `warning`, `error`). Any missing or unrecognised
	/// value results in `.off`, so no logging is produced in production builds unless
	/// the key is explicitly set.
	private static func configureLogging() {
		let rawLevel = Bundle.main.infoDictionary?["LOG_LEVEL"] as? String
		switch rawLevel?.lowercased() {
			case "verbose": SwiftLogger.level = .verbose
			case "debug":   SwiftLogger.level = .debug
			case "info":    SwiftLogger.level = .info
			case "warning": SwiftLogger.level = .warning
			case "error":   SwiftLogger.level = .error
			default:        SwiftLogger.level = .off
		}
	}
}

/// The production SwiftUI application.
///
/// Manages the top-level scene, app appearance, local authentication timeout,
/// and the privacy overlay shown when the app moves to the background.
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
	
	/// The root scene, containing the coordinator view and the privacy overlay.
	var body: some Scene {
		WindowGroup {
			content
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
	
	/// The main content view: the coordinator wrapped in a `GeometryReader` to
	/// propagate safe area insets, with the privacy overlay stacked on top.
	@ViewBuilder private var content: some View {
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
	
	/// Handle the app when we become inactive (i.e. show privacy scene)
	private func becomesInactive() {
		showPrivacyScene = true
	}
	
	/// Handle the app when we become active (again).
	private func becomesActive() {
		showPrivacyScene = false
	}
}

/// A minimal SwiftUI application used as the host when running UI tests.
///
/// Presents an empty `WindowGroup` so XCTest can attach to the process without
/// any production UI being initialised. Animations are disabled and accelerated
/// to keep test runs fast and deterministic.
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
	
	/// An empty scene — tests drive the UI directly via XCUIApplication.
	/// See https://qualitycoding.org/bypass-swiftui-app-launch-unit-testing/
	var body: some Scene {
		WindowGroup { /* an empty scene*/ }
	}
}
