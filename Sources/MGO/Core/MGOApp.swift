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
		
		// https://www.pointfree.co/episodes/ep16-dependency-injection-made-easy
		Current = services()
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
	
	/// The application coordinator to determine what view to show
	private var coordinator: AppCoordinator
	
	/// Create the production app
	init() {
		coordinator = AppCoordinator(path: NavigationStackBackport.NavigationPath())
	}
	
	var body: some Scene {
		WindowGroup {
			GeometryReader { geo in
				AppCoordinatorView<AppCoordinator>(appCoordinator: coordinator)
					.environment(\.safeAreaInsets, geo.safeAreaInsets)
					.preferredColorScheme(selectedAppearance.colorScheme)
			}
		}
	}
}

struct TestApp: App {
	
	init() {
		
		// Only run tests on a iPhone 16 Pro (screenshot dimensions will differ on other devices)
		let device = UIDevice.current.name
		if device != "iPhone 16 Pro" {
			fatalError("Switch to using iPhone 16 Pro for these tests.")
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
