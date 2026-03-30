/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class SettingsCoordinatorStateTests: XCTestCase {
	
	private var sut: SettingsCoordinator!
	private var parentCoordinator: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		parentCoordinator = DashboardCoordinatorSpy()
	}
	
	@MainActor private func createSut() {
		
		sut = SettingsCoordinator(parentCoordinator: parentCoordinator)
	}
	
	@MainActor func test_coordinatorView_forSettings() throws {
		
		// Given
		createSut()
		let state = SettingsCoordination.State.settings
		
		// When
		let view = sut.view(for: state)
		
		// Then
		let settingsView = try view.inspect().find(SettingsView.self)
		expect(settingsView) != nil
	}
	
	@MainActor func test_coordinatorView_forDisplaySettings() throws {
		
		// Given
		createSut()
		let state = SettingsCoordination.State.displaySettings
		
		// When
		let view = sut.view(for: state)
		
		// Then
		let displaySettingsView = try view.inspect().find(DisplaySettingsView.self)
		expect(displaySettingsView) != nil
	}
	
	@MainActor func test_coordinatorView_forAdvancedSettings() throws {
		
		// Given
		createSut()
		let state = SettingsCoordination.State.advancedSettings
		
		// When
		let view = sut.view(for: state)
		
		// Then
		let advancedSettingsView = try view.inspect().find(AdvancedSettingsView.self)
		expect(advancedSettingsView) != nil
	}
	
	@MainActor func test_coordinatorView_forAboutTheApp() throws {
		
		// Given
		createSut()
		let state = SettingsCoordination.State.aboutTheApp
		
		// When
		let view = sut.view(for: state)
		
		// Then
		let aboutTheAppView = try view.inspect().find(AboutTheAppView.self)
		expect(aboutTheAppView) != nil
	}
	
	@MainActor func test_coordinatorView_forAboutAccessibility() throws {
		
		// Given
		createSut()
		let state = SettingsCoordination.State.aboutAccessibility
		
		// When
		let view = sut.view(for: state)
		
		// Then
		let aboutAccessibilityView = try view.inspect().find(AboutAccessibilityView.self)
		expect(aboutAccessibilityView) != nil
	}
	
	@MainActor func test_coordinatorView_forAboutSafetyTips() throws {
		
		// Given
		createSut()
		let state = SettingsCoordination.State.aboutSafetyTips
		
		// When
		let view = sut.view(for: state)
		
		// Then
		let aboutSafetyTipsView = try view.inspect().find(AboutSafetyTipsView.self)
		expect(aboutSafetyTipsView) != nil
	}
	
	@MainActor func test_coordinatorView_forAboutOpenSourceLibraries() throws {
		
		// Given
		createSut()
		let state = SettingsCoordination.State.aboutOpenSourceLibraries
		
		// When
		let view = sut.view(for: state)
		
		// Then
		let aboutOpenSourceLibrariesView = try view.inspect().find(AboutOpenSourceLibrariesView.self)
		expect(aboutOpenSourceLibrariesView) != nil
	}
	
	@MainActor func test_coordinatorView_privacyStatement() throws {
		
		// Given
		createSut()
		let url = try XCTUnwrap(URL(string: "https://example.com"))
		let state = SettingsCoordination.State.browser(url, "privacy.heading")
		
		// When
		let view = sut.view(for: state)
		let content = NavigationStackBackport.NavigationStack { view }
		let webview = try content.inspect().find(viewWithAccessibilityIdentifier: "restrictedBrowserView")
		
		// Then
		expect(webview) != nil
	}
	
	@MainActor func test_coordinatorView_forVersion() throws {
		
		// Given
		servicesSpies.patientFriendlyTermsRepositorySpy.stubbedETag = "Test ETag"
		servicesSpies.resourceRepositorySpy.stubbedGetVersionResult = SharedCategoriesVersion(
			version: "test version",
			gitRef: "test",
			created: "today"
		)
		
		createSut()
		let state = SettingsCoordination.State.version
		
		// When
		let view = sut.view(for: state)
		
		// Then
		let settingsView = try view.inspect().find(VersionView.self)
		expect(settingsView) != nil
	}
}
