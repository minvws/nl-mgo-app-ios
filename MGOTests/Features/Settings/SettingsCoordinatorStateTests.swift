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
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	@MainActor func test_coordinatorView_forSettings_noBiometricType() throws {
		
		// Given
		createSut()
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .none }
		let state = SettingsCoordination.State.settings
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	@MainActor func test_coordinatorView_forDisplaySettings() throws {
		
		// Given
		createSut()
		let state = SettingsCoordination.State.displaySettings
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	@MainActor func test_coordinatorView_forSecuritySettings() throws {
		
		// Given
		createSut()
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .faceID }
		let state = SettingsCoordination.State.securitySettings
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	@MainActor func test_coordinatorView_forAdvancedSettings() throws {
		
		// Given
		createSut()
		let state = SettingsCoordination.State.advancedSettings
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	@MainActor func test_coordinatorView_forAboutTheApp() throws {
		
		// Given
		createSut()
		let state = SettingsCoordination.State.aboutTheApp
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
		takeSnapShotsForiPad(content: try XCTUnwrap(view))
	}
	
	@MainActor func test_coordinatorView_forAboutAccessibility() throws {
		
		// Given
		createSut()
		let state = SettingsCoordination.State.aboutAccessibility
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	@MainActor func test_coordinatorView_forAboutSafetyTips() throws {
		
		// Given
		createSut()
		let state = SettingsCoordination.State.aboutSafetyTips
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	@MainActor func test_coordinatorView_forAboutOpenSourceLibraries() throws {
		
		// Given
		createSut()
		let state = SettingsCoordination.State.aboutOpenSourceLibraries
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	@MainActor func test_coordinatorView_privacyStatement() throws {
		
		// Given
		createSut()
		let url = try XCTUnwrap(URL(string: "https://example.com"))
		let state = SettingsCoordination.State.browser(url, "privacy.heading")
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		let webview = try content.inspect().find(viewWithAccessibilityIdentifier: "restrictedBrowserView")
		
		// Then
		expect(webview) != nil
	}
	
	@MainActor func test_coordinatorView_forVersion() throws {
		
		// Given
		createSut()
		servicesSpies.patientFriendlyTermsRepositorySpy.stubbedETag = "Test ETag"
		servicesSpies.resourceRepositorySpy.stubbedGetVersionResult = SharedCategoriesVersion(
			version: "test version",
			gitRef: "test",
			created: "today"
		)
		
		let state = SettingsCoordination.State.version
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
}
