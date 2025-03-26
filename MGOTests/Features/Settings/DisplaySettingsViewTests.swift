/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO
import MGOUI

final class DisplaySettingsViewTests: XCTestCase {
	
	private var sut: DisplaySettingsView!
	
	override func tearDown() {
		super.tearDown()
		UserDefaults.standard.set(nil, forKey: "AppAppearance")
	}
	
	func test_displaySettingsView_systemSelected() {
		
		// Given
		UserDefaults.standard.set(nil, forKey: "AppAppearance")
		sut = DisplaySettingsView()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
		takeSnapShotsForiPad(content: content)
	}
	
	func disabled_test_displaySettingsView_selectLight() throws {
		
		// Given
		UserDefaults.standard.set(nil, forKey: "AppAppearance")
		sut = DisplaySettingsView()
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "settings.display.light")
		try view.button().tap()
		
		// Then
		expect(UserDefaults.standard.string(forKey: "AppAppearance")).toEventually(equal("light"))
	}
	
	func disabled_test_displaySettingsView_selectDark() throws {
		
		// Given
		UserDefaults.standard.set(nil, forKey: "AppAppearance")
		sut = DisplaySettingsView()
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "settings.display.dark")
		try view.button().tap()
		
		// Then
		expect(UserDefaults.standard.string(forKey: "AppAppearance")).toEventually(equal("dark"))
	}
	
	func disabled_test_displaySettingsView_selectSystem() throws {
		
		// Given
		UserDefaults.standard.set("light", forKey: "AppAppearance")
		sut = DisplaySettingsView()
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "settings.display.system")
		try view.button().tap()
		
		// Then
		expect(UserDefaults.standard.string(forKey: "AppAppearance")).toEventually(equal("system"))
	}
}
