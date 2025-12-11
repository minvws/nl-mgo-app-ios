/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
@testable import MGO
import MGOUI

final class AboutTheAppViewTests: XCTestCase {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: AboutTheAppView!

	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
	}
	
	@MainActor private func createSut() {
		
		sut = AboutTheAppView(
			viewModel: AboutTheAppViewModel(
				coordinator: self.coordinatorSpy
			)
		)
	}

	@MainActor func test_aboutTheAppView() {
		
		// Given
		createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
		takeSnapShotsForiPad(content: content)
	}
	
	@MainActor func test_backbuttonPressed() throws {
		
		// Given
		createSut()
		let content = NavigationView { sut }
		
		// When
		try content.inspect().find(viewWithAccessibilityIdentifier: "common.previous").button().tap()

		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
	
	@MainActor func test_showSafetyTips() throws {
		
		// Given
		createSut()
		let content = NavigationView { sut }
		
		// When
		try content.inspect().find(viewWithAccessibilityIdentifier: "settings.about_this_app.safety").button().tap()

		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showSafetyTips
	}
	
	@MainActor func test_showAccessibility() throws {
		
		// Given
		createSut()
		let content = NavigationView { sut }
		
		// When
		try content.inspect().find(viewWithAccessibilityIdentifier: "settings.about_this_app.accessibility").button().tap()

		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showAccessibility
	}
	
	@MainActor func test_showOpenSourceLibraries() throws {
		
		// Given
		createSut()
		let content = NavigationView { sut }
		
		// When
		try content.inspect().find(viewWithAccessibilityIdentifier: "settings.about_this_app.open_source").button().tap()

		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showOpenSourceLibraries
	}
	
	@MainActor func test_showPrivacyStatement() throws {
		
		// Given
		createSut()
		let content = NavigationView { sut }
		
		// When
		try content.inspect().find(viewWithAccessibilityIdentifier: "settings.about_this_app.privacy").button().tap()

		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showPrivacyStatement
	}
	
	@MainActor func test_showHCIMVersion() throws {
		
		// Given
		createSut()
		let content = NavigationView { sut }
		
		// When
		try content.inspect().find(viewWithAccessibilityIdentifier: "settings.about_this_app.version").button().tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showVersion
	}
}
