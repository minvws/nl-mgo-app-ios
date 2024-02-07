/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
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
	
	var body: some Scene {
		WindowGroup {
			AppCoordinatorView<AppCoordinator>(appCoordinator: AppCoordinator(path: NavigationStackBackport.NavigationPath()))
		}
	}
}

struct TestApp: App {
	
	init() {
		
		// Only run tests on a iPhone 15 Pro (screenshot dimensions will differ on other devices)
		let device = UIDevice.current.name
		if device != "iPhone 15 Pro" {
			fatalError("Switch to using iPhone 15 Pro for these tests.")
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
