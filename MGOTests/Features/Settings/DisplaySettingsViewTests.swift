/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO
import MGOUI

final class DisplaySettingsViewTests: XCTestCase {
	
	private var coordinatorSpy: SettingsCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: DisplaySettingsView!

	override func tearDown() {
		super.tearDown()
		UserDefaults.standard.set(nil, forKey: "AppAppearance")
	}
	
	override func setUp() {
		
		servicesSpies = setupServicesSpies()
		coordinatorSpy = SettingsCoordinatorSpy()
		sut = DisplaySettingsView(viewModel: BaseViewModel(coordinator: self.coordinatorSpy))
		super.setUp()
	}
	
	func test_displaySettingsView_systemSelected() {
		
		// Given
		UserDefaults.standard.set(nil, forKey: "AppAppearance")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
		takeSnapShotsForiPad(content: content)
	}
	
	func test_displaySettingsView_selectLight() throws {
		
		// Given
		UserDefaults.standard.set(nil, forKey: "AppAppearance")
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "settings.display.light")
		try view.find(button: "settings.display.light").tap()
		
		// Then
		expect(UserDefaults.standard.string(forKey: "AppAppearance")).toEventually(equal("light"))
	}
	
	func test_displaySettingsView_selectDark() throws {
		
		// Given
		UserDefaults.standard.set(nil, forKey: "AppAppearance")
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "settings.display.dark")
		try view.find(button: "settings.display.dark").tap()
		
		// Then
		expect(UserDefaults.standard.string(forKey: "AppAppearance")).toEventually(equal("dark"))
	}
	
	func test_displaySettingsView_selectSystem() throws {
		
		// Given
		UserDefaults.standard.set("light", forKey: "AppAppearance")
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "settings.display.system")
		try view.find(button: "settings.display.system.heading").tap()
		
		// Then
		expect(UserDefaults.standard.string(forKey: "AppAppearance")).toEventually(equal("system"))
	}
	
	func test_backbuttonPressed() throws {
		
		// Given
		let content = NavigationView { sut }
		
		// When
		try content.inspect().find(viewWithAccessibilityIdentifier: "common.previous").button().tap()

		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
}
