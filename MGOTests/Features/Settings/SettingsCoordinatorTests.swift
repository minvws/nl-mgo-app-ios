/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO
import RestrictedBrowser

final class SettingsCoordinatorTests: XCTestCase {
	
	private var sut: SettingsCoordinator!
	private var parentCoordinator: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var urlOpenerSpy: URLOpenerSpy!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let browser = RestrictedBrowser(allowedDomains: ["irealisatie.nl"], urlOpener: urlOpenerSpy)
		parentCoordinator = DashboardCoordinatorSpy()
		sut = SettingsCoordinator(parentCoordinator: parentCoordinator, browser: browser)
	}
	
	// MARK: - Handle -
	
	@MainActor func test_coordinatorHandle_backButtonPressed() {
		
		// Given
		sut.path = NavigationStackBackport.NavigationPath([SettingsCoordination.State.displaySettings])
		
		// When
		sut.handle(Coordination.Action.backButtonPressed)
		
		// Then
		expect(self.sut.path.isEmpty) == true
	}
	
	@MainActor func test_coordinatorHandle_showDisplaySettings() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.showDisplaySettings)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([SettingsCoordination.State.displaySettings])
	}
	
	@MainActor func test_coordinatorHandle_showSecuritySettings() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.showSecuritySettings)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([SettingsCoordination.State.securitySettings])
	}
	
	@MainActor func test_coordinatorHandle_showAdvancedSettings() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.showAdvancedSettings)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([SettingsCoordination.State.advancedSettings])
	}
	
	@MainActor func test_coordinatorHandle_showAboutTheApp() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.showAboutTheApp)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([SettingsCoordination.State.aboutTheApp])
	}
	
	@MainActor func test_coordinatorHandle_showAboutAccessibility() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.showAccessibility)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([SettingsCoordination.State.aboutAccessibility])
	}
	
	@MainActor func test_coordinatorHandle_showSafetyTips() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.showSafetyTips)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([SettingsCoordination.State.aboutSafetyTips])
	}
	
	@MainActor func test_coordinatorHandle_showOpenSourceLibraries() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.showOpenSourceLibraries)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([SettingsCoordination.State.aboutOpenSourceLibraries])
	}
	
	@MainActor func test_coordinatorHandle_openUrl() {
		
		// Given
		let params: [String: AnyHashable] = ["urlString": "https://example.com"]
		
		// When
		sut.handle(Coordination.Action(identifier: Coordination.Action.openUrl.identifier, params: params))
		
		// Then
		expect(self.urlOpenerSpy.invokedOpen).toEventually(beTrue())
	}
	
	@MainActor func test_coordinatorHandle_openUrl_wrongParams() {
		
		// Given
		let params: [String: AnyHashable] = ["wrongParam": "https://example.com"]
		
		// When
		sut.handle(Coordination.Action(identifier: Coordination.Action.openUrl.identifier, params: params))
		
		// Then
		expect(self.urlOpenerSpy.invokedOpen).toEventually(beFalse())
	}
	
	@MainActor func test_coordinatorHandle_lockAppliction() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.lockApplication)
		
		// Then
		expect(self.servicesSpies.notificationCenterSpy.invokedPostName) == true
	}
	
	@MainActor func test_coordinatorHandle_showPrivacyStatement() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.showPrivacyStatement)
		
		// Then
		expect(self.urlOpenerSpy.invokedOpen).toEventually(beTrue())
	}
	
	@MainActor func test_coordinatorHandle_resetApplication() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.resetApplication)
		
		// Then
		expect(self.parentCoordinator.invokedHandle) == true
		expect(self.parentCoordinator.invokedHandleParameters?.0) == Coordination.Action.resetApplication
	}
}
