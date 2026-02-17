/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO
import RemoteConfiguration
import RestrictedBrowser

// swiftlint:disable type_body_length
final class AppCoordinatorTests: XCTestCase {
	
	private var sut: AppCoordinator!
	private var servicesSpies: ServicesSpies!
	private var urlOpenerSpy: URLOpenerSpy!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
	}
	
	@MainActor func setupSut() {
		
		let browser = RestrictedBrowser(
			allowedDomains: ["irealisatie.nl"],
			urlOpener: urlOpenerSpy
		)
		sut = AppCoordinator(
			path: NavigationStackBackport.NavigationPath(),
			browser: browser
		)
	}
	
	// MARK: - Observe -
	
	@MainActor func test_observe_remoteConfig() throws {
		
		// Given
		Container.shared.remoteConfigurationRepository.register {
			RemoteConfigurationRepository(
				apiClient: RemoteConfigurationClient(
					serverUrl: Configuration().urlForRemoteConfiguration()
				)
			)
		}
		setupSut()
		servicesSpies.appVersionSupplierSpy.stubbedGetCurrentVersionResult = "1.0.0"
		let remoteConfig = RemoteConfig(iosMinimumVersion: "1.0.1")
		
		// When
		Container.shared.remoteConfigurationRepository()
			.observatory.notifyObservers(newValue: remoteConfig)
		
		// Then
		expect(self.sut.rootState)
			.toEventually(equal(AppCoordination.State.updateRequired))
		expect(self.sut.path.isEmpty) == true
	}
	
	// MARK: - Handle -
	
	@MainActor func test_coordinatorHandle_actionFinishedSplash_appIntroductionNotSeen_pathShouldContainAppIntroduction() {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedFirstTimeVisitor = true
		setupSut()
		
		// When
		sut.handle(Coordination.Action.finishedSplash)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.introduction
		expect(self.sut.path.isEmpty) == true
		expect(
			self.servicesSpies.secureUserSettingsSpy.invokedFirstTimeVisitorGetter
		) == true
	}
	
	@MainActor func test_coordinatorHandle_actionFinishedSplash_appIntroductionSeen_bypassPincodeEnabled() {
		
		// Given
		setupSut()
		servicesSpies.secureUserSettingsSpy.stubbedPinCode = "test"
		servicesSpies.featureFlagSpy.stubbedBypassPincode = true
		
		// When
		sut.handle(Coordination.Action.finishedSplash)
		
		// Then
		expect(self.sut.showChildCoordinator) == true
		expect(self.sut.path.isEmpty) == true
	}
	
	@MainActor func test_coordinatorHandle_actionNextButtonPressedOnAppIntroduction_pathShouldContainPrivacy() {
		
		// Given
		setupSut()
		
		// When
		sut.handle(Coordination.Action.nextButtonPressedOnIntroduction)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.proposition])
	}
	
	@MainActor func test_coordinatorHandle_actionNextButtonPressedOnPrivacy_pathShouldContainLogin() {
		
		// Given
		setupSut()
		
		// When
		sut.handle(Coordination.Action.nextButtonPressedOnProposition)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.splash
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.login])
	}
	
	@MainActor func test_coordinatorHandle_showPrivacyStatement_shouldShowPrivacyStatement_domainNotAllowed() {
		
		// Given
		setupSut()
		
		// When
		sut.handle(Coordination.Action.showPrivacyStatement)
		
		// Then
		expect(self.sut.path.isEmpty) == true
		expect(self.urlOpenerSpy.invokedOpen).toEventually(beTrue())
	}
	
	@MainActor func test_coordinatorHandle_showPrivacyStatement_shouldShowPrivacyStatement_domainAllowed() throws {
		
		// Given
		let browser = RestrictedBrowser(allowedDomains: ["web.test.mgo.irealisatie.nl"], urlOpener: urlOpenerSpy)
		sut = AppCoordinator(path: NavigationStackBackport.NavigationPath(), browser: browser)
		
		// When
		sut.handle(Coordination.Action.showPrivacyStatement)
		
		// Then
		expect(self.sut.path.isEmpty) == true
		let url = try XCTUnwrap(LinkRepository.privacyURL)
		expect(self.sut.rootStateForSheet) == AppCoordination.State.browser(url, "privacy.heading")
		expect(self.urlOpenerSpy.invokedOpen) == false
	}
	
	@MainActor func test_coordinatorHandle_loginWithDigiD_shouldShowDashboard_whenAutomaticLocalizationEnabled() {
		
		// Given
		setupSut()
		self.servicesSpies.featureFlagSpy.stubbedIsAutomaticLocalizationEnabled = false
		
		// When
		sut.handle(Coordination.Action.loggedInWithDigiD)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.loginInfo
		expect(self.sut.path.isEmpty) == true
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasRemoteAuthenticationSetter) == true
	}
	
	@MainActor func test_coordinatorHandle_nextButtonPressedOnLoginInfo_shouldShowManualLocalizaion_whenAutomaticLocalizationEnabled() {
		
		// Given
		setupSut()
		self.servicesSpies.featureFlagSpy.stubbedIsAutomaticLocalizationEnabled = false
		
		// When
		sut.handle(Coordination.Action.nextButtonPressedOnLoginInfo)
		
		// Then
		expect(self.sut.showChildCoordinator) == false
		expect(self.sut.path.isEmpty) == true
		expect(self.sut.rootState) == AppCoordination.State.manualLocalization
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasRemoteAuthenticationSetter) == false
	}
	
	@MainActor func test_coordinatorHandle_nextButtonPressedOnLoginInfo_shouldAutomaticLocalization_whenAutomaticLocalizationEnabled() {
		
		// Given
		setupSut()
		
		// When
		sut.handle(Coordination.Action.nextButtonPressedOnLoginInfo)
		
		// Then
		expect(self.sut.showChildCoordinator) == false
		expect(self.sut.rootState) == AppCoordination.State.automaticLocalization
		expect(self.sut.path.isEmpty) == true
	}
	
	@MainActor func test_coordinatorHandle_search_shouldContainHealthcareOrganizationSearchResults() {
		
		// Given
		setupSut()
		
		// When
		sut.handle(Coordination.Action(identifier: "showHealthcareOrganizationSearchResults", params: ["city": "Roermond", "name": "Tandarts Tandje Erbij"]))

		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.healthcareOrganizationSearchResults(city: "Roermond", name: "Tandarts Tandje Erbij")])
	}
	
	@MainActor func test_coordinatorHandle_search_wrongParams() {
		
		// Given
		setupSut()
		
		// When
		sut.handle(Coordination.Action(identifier: "showHealthcareOrganizationSearchResults", params: ["city": "Roermond", "wrong param": "Tandarts Tandje Erbij"]))

		// Then
		expect(self.sut.path.isEmpty) == true
	}
	
	@MainActor func test_coordinatorHandle_backToAddHealthcareOrganization() {
		
		// Given
		setupSut()
		sut.path = NavigationStackBackport.NavigationPath([AppCoordination.State.healthcareOrganizationSearchResults(city: "wrong", name: "wrong")])
		
		// When
		sut.handle(Coordination.Action.backToAddHealthcareOrganization)
		
		// Then
		expect(self.sut.path.isEmpty) == true
	}
	
	@MainActor func test_coordinatorHandle_finishedSearchingHealthcareOrganizations_shouldShowDashboard() {
		
		// Given
		setupSut()
		
		// When
		sut.handle(Coordination.Action.finishedSearchingHealthcareOrganizations)
		
		// Then
		expect(self.sut.showChildCoordinator) == true
		expect(self.sut.path.isEmpty) == true
	}
	
	@MainActor func test_coordinatorHandle_backButtonPressed() {
		
		// Given
		setupSut()
		sut.path = NavigationStackBackport.NavigationPath([AppCoordination.State.introduction])
		
		// When
		sut.handle(Coordination.Action.backButtonPressed)
		
		// Then
		expect(self.sut.path.isEmpty) == true
	}
	
	@MainActor func test_coordinatorHandle_backButtonPressed_emptyPath() {
		
		// Given
		setupSut()
		sut.path = NavigationStackBackport.NavigationPath()
		
		// When
		sut.handle(Coordination.Action.backButtonPressed)
		
		// Then
		expect(self.sut.path.isEmpty) == true
	}
	
	@MainActor func test_coordinatorHandle_resetApplication() {
		
		// Given
		setupSut()
		sut.path = NavigationStackBackport.NavigationPath([AppCoordination.State.introduction])
		
		// When
		sut.handle(Coordination.Action.resetApplication)
		
		// Then
		expect(self.sut.path.isEmpty) == true
		expect(self.sut.rootState) == .splash
		expect(self.servicesSpies.secureUserSettingsSpy.invokedWipePersistedDataCount) == 1
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedWipePersistedDataCount) == 1
	}
	
	@MainActor func test_coordinatorHandle_updateRequired() {
		
		// Given
		setupSut()
		
		// When
		sut.handle(Coordination.Action.updateRequired)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.updateRequired
		expect(self.sut.path.isEmpty) == true
	}
	
	@MainActor func test_handleRemoteConfigChanges_identicalVersion() {
		
		// Given
		setupSut()
		servicesSpies.appVersionSupplierSpy.stubbedGetCurrentVersionResult = "1.0.0"
		let remoteConfig = RemoteConfig(iosMinimumVersion: "1.0.0")
		
		// When
		sut.handleRemoteConfigChanges(remoteConfiguration: remoteConfig)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.splash
		expect(self.sut.path.isEmpty) == true
	}
	
	@MainActor func test_handleRemoteConfigChanges_shouldContinue() {
		
		// Given
		setupSut()
		servicesSpies.appVersionSupplierSpy.stubbedGetCurrentVersionResult = "1.0.1"
		let remoteConfig = RemoteConfig(iosMinimumVersion: "1.0.0")
		
		// When
		sut.handleRemoteConfigChanges(remoteConfiguration: remoteConfig)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.splash
		expect(self.sut.path.isEmpty) == true
	}
	
	@MainActor func test_handleRemoteConfigChanges_shouldUpdate() {
		
		// Given
		setupSut()
		servicesSpies.appVersionSupplierSpy.stubbedGetCurrentVersionResult = "1.0.0"
		let remoteConfig = RemoteConfig(iosMinimumVersion: "1.0.1")
		
		// When
		sut.handleRemoteConfigChanges(remoteConfiguration: remoteConfig)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.updateRequired
		expect(self.sut.path.isEmpty) == true
	}
	
	@MainActor func test_coordinatorHandle_showAppStore() {
		
		// Given
		setupSut()
		
		// When
		sut.handle(Coordination.Action.showAppStore)
		
		// Then
		expect(self.urlOpenerSpy.invokedOpen).toEventually(beTrue())
	}
	
	@MainActor func test_coordinatorHandle_showAppStore_evenWhenUpdateRequired() {
		
		// Given
		setupSut()
		sut.handle(Coordination.Action.updateRequired)
		
		// When
		sut.handle(Coordination.Action.showAppStore)
		
		// Then
		expect(self.urlOpenerSpy.invokedOpen).toEventually(beTrue())
	}
}
// swiftlint:enable type_body_length
