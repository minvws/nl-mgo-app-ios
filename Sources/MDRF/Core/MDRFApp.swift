/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GifzUI
import GifzFoundation

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
	
	var body: some Scene {
		WindowGroup {
			MainContentView(appCoordinator: AppCoordinator(path: NavigationStackBackport.NavigationPath()))
		}
	}
}

struct TestApp: App {
	
	var body: some Scene {
		WindowGroup {
			// Nothing for the test app
			// See https://qualitycoding.org/bypass-swiftui-app-launch-unit-testing/
		}
	}
}
