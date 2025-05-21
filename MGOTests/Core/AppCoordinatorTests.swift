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

final class AppCoordinatorTests: XCTestCase {
	
	private var sut: AppCoordinator!
	private var servicesSpies: ServicesSpies!
	private var urlOpenerSpy: URLOpenerSpy!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let browser = RestrictedBrowser(allowedDomains: ["irealisatie.nl"], urlOpener: urlOpenerSpy)
		sut = AppCoordinator(
			path: NavigationStackBackport.NavigationPath(),
			browser: browser
		)
	}
	
	// MARK: - Handle -
	
	func test_coordinatorHandle_actionFinishedSplash_appIntroductionNotSeen_pathShouldContainAppIntroduction() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.finishedSplash)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.introduction
		expect(self.sut.path.isEmpty) == true
		expect(self.servicesSpies.secureUserSettingsSpy.invokedPinCodeGetter) == true
	}
	
	func test_coordinatorHandle_actionFinishedSplash_appIntroductionSeen_accessCodeSet_pathShouldContainPinCodeValidation() {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedPinCode = "test"
		
		// When
		sut.handle(Coordination.Action.finishedSplash)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.pinCodeValidation(lockOut: false)
		expect(self.sut.path.isEmpty) == true
		expect(self.servicesSpies.secureUserSettingsSpy.invokedPinCodeGetter) == true
	}
	
	func test_coordinatorHandle_actionFinishedSplash_appIntroductionSeen_bypassPincodeEnabled() {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedPinCode = "test"
		servicesSpies.featureFlagSpy.stubbedBypassPincode = true
		
		// When
		sut.handle(Coordination.Action.finishedSplash)
		
		// Then
		expect(self.sut.showChildCoordinator) == true
		expect(self.sut.path.isEmpty) == true
	}
	
	func test_coordinatorHandle_actionNextButtonPressedOnAppIntroduction_pathShouldContainPrivacy() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.nextButtonPressedOnIntroduction)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.proposition])
	}
	
	func test_coordinatorHandle_actionNextButtonPressedOnPrivacy_pathShouldContainPinCodeEntry() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.nextButtonPressedOnProposition)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.splash
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.pinCodeEntry(backButtonVisible: true)])
	}
	
	func test_coordinatorHandle_showPrivacyStatement_shouldShowPrivacyStatement_domainNotAllowed() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.showPrivacyStatement)
		
		// Then
		expect(self.sut.path.isEmpty) == true
		expect(self.urlOpenerSpy.invokedOpen).toEventually(beTrue())
	}
	
	func test_coordinatorHandle_showPrivacyStatement_shouldShowPrivacyStatement_domainAllowed() {
		
		// Given
		let browser = RestrictedBrowser(allowedDomains: ["web.test.mgo.irealisatie.nl"], urlOpener: urlOpenerSpy)
		sut = AppCoordinator(path: NavigationStackBackport.NavigationPath(), browser: browser)
		
		// When
		sut.handle(Coordination.Action.showPrivacyStatement)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.privacyStatement])
		expect(self.urlOpenerSpy.invokedOpen) == false
	}
	
	func test_coordinatorHandle_accessCodeEntered_shouldShowPinCodeConfirmation() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.pinCodeEntered)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.pinCodeConfirmation])
	}
	
	func test_coordinatorHandle_accessCodeConfirmed_shouldShowBioMetricSetup() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .faceID }
		
		// When
		sut.handle(Coordination.Action.pinCodeConfirmed)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.bioMetricSetup
		expect(self.sut.path.isEmpty) == true
	}
	
	func test_coordinatorHandle_accessCodeConfirmed_noBiometrics_shouldShowRemoteAuthentication() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .none }
		
		// When
		sut.handle(Coordination.Action.pinCodeConfirmed)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.login
		expect(self.sut.path.isEmpty) == true
	}
	
	func test_coordinatorHandle_didFinishLocalAuthentication_shouldShowRemoteAuthenciation() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.didFinishLocalAuthentication)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.login
		expect(self.sut.path.isEmpty) == true
	}
	
	func test_coordinatorHandle_loginWithDigiD_shouldShowDashboard_whenAutomaticLocalizationEnabled() {
		
		// Given
		self.servicesSpies.featureFlagSpy.stubbedIsAutomaticLocalizationEnabled = false
		
		// When
		sut.handle(Coordination.Action.loggedInWithDigiD)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.loginInfo
		expect(self.sut.path.isEmpty) == true
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasRemoteAuthenticationSetter) == true
	}
	
	func test_coordinatorHandle_nextButtonPressedOnLoginInfo_shouldShowManualLocalizaion_whenAutomaticLocalizationEnabled() {
		
		// Given
		self.servicesSpies.featureFlagSpy.stubbedIsAutomaticLocalizationEnabled = false
		
		// When
		sut.handle(Coordination.Action.nextButtonPressedOnLoginInfo)
		
		// Then
		expect(self.sut.showChildCoordinator) == false
		expect(self.sut.path.isEmpty) == true
		expect(self.sut.rootState) == AppCoordination.State.manualLocalization
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasRemoteAuthenticationSetter) == false
	}
	
	func test_coordinatorHandle_nextButtonPressedOnLoginInfo_shouldAutomaticLocalization_whenAutomaticLocalizationEnabled() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.nextButtonPressedOnLoginInfo)
		
		// Then
		expect(self.sut.showChildCoordinator) == false
		expect(self.sut.rootState) == AppCoordination.State.automaticLocalization
		expect(self.sut.path.isEmpty) == true
	}
	
	func test_coordinatorHandle_search_shouldContainHealthcareOrganizationSearchResults() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "showHealthcareOrganizationSearchResults", params: ["city": "Roermond", "name": "Tandarts Tandje Erbij"]))

		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.healthcareOrganizationSearchResults(city: "Roermond", name: "Tandarts Tandje Erbij")])
	}
	
	func test_coordinatorHandle_search_wrongParams() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "showHealthcareOrganizationSearchResults", params: ["city": "Roermond", "wrong param": "Tandarts Tandje Erbij"]))

		// Then
		expect(self.sut.path.isEmpty) == true
	}
	
	func test_coordinatorHandle_backToAddHealthcareOrganization() {
		
		// Given
		sut.path = NavigationStackBackport.NavigationPath([AppCoordination.State.healthcareOrganizationSearchResults(city: "wrong", name: "wrong")])
		
		// When
		sut.handle(Coordination.Action.backToAddHealthcareOrganization)
		
		// Then
		expect(self.sut.path.isEmpty) == true
	}
	
	func test_coordinatorHandle_finishedSearchingHealthcareOrganizations_shouldShowDashboard() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.finishedSearchingHealthcareOrganizations)
		
		// Then
		expect(self.sut.showChildCoordinator) == true
		expect(self.sut.path.isEmpty) == true
	}
	
	func test_coordinatorHandle_codeValidated_shouldShowRemoteAuthentication() {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedUserHasRemoteAuthentication = false
		
		// When
		sut.handle(Coordination.Action.pinCodeValidated)
		
		// Then
		expect(self.sut.showChildCoordinator) == false
		expect(self.sut.rootState) == AppCoordination.State.login
		expect(self.sut.path.isEmpty) == true
	}
	
	func test_coordinatorHandle_codeValidated_remoteAuthenticationDone_shouldShowDashboard() {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedUserHasRemoteAuthentication = true
		
		// When
		sut.handle(Coordination.Action.pinCodeValidated)
		
		// Then
		expect(self.sut.showChildCoordinator) == true
	}
	
	func test_coordinatorHandle_codeValidated_whenReturningFromBackground() {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedEnteredBackground = Date()
		
		// When
		sut.handle(Coordination.Action.pinCodeValidated)
		
		// Then
		expect(self.servicesSpies.secureUserSettingsSpy.invokedEnteredBackground) == nil
		expect(self.sut.showAuthenticationModal) == false
	}
	
	func test_coordinatorHandle_pinCodeValidatedAfterLockout() {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedUserHasRemoteAuthentication = false
		servicesSpies.secureUserSettingsSpy.stubbedEnteredBackground = Date()
		
		// When
		sut.handle(Coordination.Action.pinCodeValidatedAfterLockout)
		
		// Then
		expect(self.sut.showAuthenticationModal) == false
		expect(self.sut.rootStateForSheet) == nil
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath()
		expect(self.servicesSpies.secureUserSettingsSpy.invokedEnteredBackground) == nil
	}
	
	func test_coordinator_receiveNotification_whenReturningFromBackground_duringOnboarding() {
		
		// Given
		Current.notificationCenter = NotificationCenter.default
		let browser = RestrictedBrowser(allowedDomains: ["irealisatie.nl"], urlOpener: urlOpenerSpy)
		sut = AppCoordinator(
			path: NavigationStackBackport.NavigationPath(),
			browser: browser
		)
		sut.showChildCoordinator = false
		
		// When
		Current.notificationCenter.post(name: .showLocalAuthentication, object: nil)
		
		// Then
		expect(self.sut.showAuthenticationModal).toEventually(beFalse())
	}
	
	func test_coordinator_receiveNotification_whenReturningFromBackground_duringDashboard() {
		
		// Given
		Current.notificationCenter = NotificationCenter.default
		let browser = RestrictedBrowser(allowedDomains: ["irealisatie.nl"], urlOpener: urlOpenerSpy)
		sut = AppCoordinator(
			path: NavigationStackBackport.NavigationPath(),
			browser: browser
		)
		sut.showChildCoordinator = true
		
		// When
		Current.notificationCenter.post(name: .showLocalAuthentication, object: nil)
		
		// Then
		expect(self.sut.showAuthenticationModal).toEventually(beTrue())
	}
	
	func test_coordinatorHandle_forgotPinCode() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.forgotPinCode)
		
		// Then
		expect(self.sut.rootStateForSheet) == AppCoordination.State.forgotPinCode
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath()
	}
	
	func test_coordinatorHandle_forgotPinCode_withAuthenticationModal() {
		
		// Given
		sut.showAuthenticationModal = true
		
		// When
		sut.handle(Coordination.Action.forgotPinCode)
		
		// Then
		expect(self.sut.rootStateForSheet) == nil
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath([AppCoordination.State.forgotPinCode])
	}
	
	func test_coordinatorHandle_dismissForgotPinCode() {
		
		// Given
		sut.rootStateForSheet = AppCoordination.State.pinCodeValidation(lockOut: false)
		sut.pathForSheet = NavigationStackBackport.NavigationPath([AppCoordination.State.forgotPinCode])
		
		// When
		sut.handle(Coordination.Action.dismissForgotPinCode)
		
		// Then
		expect(self.sut.rootStateForSheet) == nil
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath()
	}
	
	func test_coordinatorHandle_dismissForgotPinCode_showAuthenticationModal() {
		
		// Given
		sut.rootStateForSheet = AppCoordination.State.pinCodeValidation(lockOut: true)
		sut.pathForSheet = NavigationStackBackport.NavigationPath([AppCoordination.State.forgotPinCode])
		sut.showAuthenticationModal = true
		
		// When
		sut.handle(Coordination.Action.dismissForgotPinCode)
		
		// Then
		expect(self.sut.rootStateForSheet) == AppCoordination.State.pinCodeValidation(lockOut: true)
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath()
	}
	
	func test_coordinatorHandle_dismissForgotPinCode_whenUpdateRequired() {
		
		// Given
		sut.handle(Coordination.Action.updateRequired)
		sut.rootStateForSheet = AppCoordination.State.forgotPinCode
		
		// When
		sut.handle(Coordination.Action.dismissForgotPinCode)
		
		// Then
		expect(self.sut.rootStateForSheet) == AppCoordination.State.forgotPinCode
	}
	
	func test_coordinatorHandle_recreateAccount() {
		
		// Given
		sut.path = NavigationStackBackport.NavigationPath([AppCoordination.State.login, AppCoordination.State.pinCodeValidation(lockOut: false)])
		sut.rootStateForSheet = AppCoordination.State.forgotPinCode
		
		// When
		sut.handle(Coordination.Action.recreateAccount)
		
		// Then
		expect(self.servicesSpies.secureUserSettingsSpy.invokedWipePersistedData) == true
		expect(self.sut.rootStateForSheet) == AppCoordination.State.accountRemoved
		expect(self.sut.rootState) == AppCoordination.State.pinCodeEntry(backButtonVisible: false)
	}
	
	func test_coordinatorHandle_recreateAccount_withAuthenticationModal() {
		
		// Given
		sut.path = NavigationStackBackport.NavigationPath([AppCoordination.State.login, AppCoordination.State.pinCodeValidation(lockOut: false)])
		sut.rootStateForSheet = AppCoordination.State.forgotPinCode
		sut.showChildCoordinator = true
		sut.showAuthenticationModal = true
		
		// When
		sut.handle(Coordination.Action.recreateAccount)
		
		// Then
		expect(self.servicesSpies.secureUserSettingsSpy.invokedWipePersistedData) == true
		expect(self.sut.rootStateForSheet) == nil
		expect(self.sut.rootState) == AppCoordination.State.accountRemoved
		expect(self.sut.showChildCoordinator) == false
		expect(self.sut.showAuthenticationModal) == false
	}
	
	func test_coordinatorHandle_restart() {
		
		// Given
		sut.path = NavigationStackBackport.NavigationPath([AppCoordination.State.accountRemoved])
		sut.rootStateForSheet = nil
		
		// When
		sut.handle(Coordination.Action.restart)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.pinCodeEntry(backButtonVisible: false)
	}
	
	func test_coordinatorHandle_backButtonPressed() {
		
		// Given
		sut.path = NavigationStackBackport.NavigationPath([AppCoordination.State.introduction])
		
		// When
		sut.handle(Coordination.Action.backButtonPressed)
		
		// Then
		expect(self.sut.path.isEmpty) == true
	}
	
	func test_coordinatorHandle_backButtonPressed_emptyPath() {
		
		// Given
		sut.path = NavigationStackBackport.NavigationPath()
		
		// When
		sut.handle(Coordination.Action.backButtonPressed)
		
		// Then
		expect(self.sut.path.isEmpty) == true
	}
	
	func test_coordinatorHandle_resetApplication() {
		
		// Given
		sut.path = NavigationStackBackport.NavigationPath([AppCoordination.State.introduction])
		
		// When
		sut.handle(Coordination.Action.resetApplication)
		
		// Then
		expect(self.sut.path.isEmpty) == true
		expect(self.sut.rootState) == .splash
		expect(self.servicesSpies.notificationCenterSpy.invokedPostName) == true
		expect(self.servicesSpies.secureUserSettingsSpy.invokedWipePersistedDataCount) == 1
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedWipePersistedDataCount) == 1
	}
	
	func test_coordinatorHandle_updateRequired() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.updateRequired)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.updateRequired
		expect(self.sut.path.isEmpty) == true
	}
	
	func test_handleRemoteConfigChanges_identicalVersion() {
		
		// Given
		servicesSpies.appVersionSupplierSpy.stubbedGetCurrentVersionResult = "1.0.0"
		let remoteConfig = RemoteConfig(iosMinimumVersion: "1.0.0")
		
		// When
		sut.handleRemoteConfigChanges(remoteConfiguration: remoteConfig)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.splash
		expect(self.sut.path.isEmpty) == true
	}
	
	func test_handleRemoteConfigChanges_shouldUpdate() {
		
		// Given
		servicesSpies.appVersionSupplierSpy.stubbedGetCurrentVersionResult = "1.0.1"
		let remoteConfig = RemoteConfig(iosMinimumVersion: "1.0.0")
		
		// When
		sut.handleRemoteConfigChanges(remoteConfiguration: remoteConfig)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.splash
		expect(self.sut.path.isEmpty) == true
	}
	
	func test_handleRemoteConfigChanges_shouldContinue() {
		
		// Given
		servicesSpies.appVersionSupplierSpy.stubbedGetCurrentVersionResult = "1.0.0"
		let remoteConfig = RemoteConfig(iosMinimumVersion: "1.0.1")
		
		// When
		sut.handleRemoteConfigChanges(remoteConfiguration: remoteConfig)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.updateRequired
		expect(self.sut.path.isEmpty) == true
	}
	
	func test_coordinatorHandle_showAppStore() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.showAppStore)
		
		// Then
		expect(self.urlOpenerSpy.invokedOpen).toEventually(beTrue())
	}
	
	func test_coordinatorHandle_showAppStore_evenWhenUpdateRequired() {
		
		// Given
		sut.handle(Coordination.Action.updateRequired)
		
		// When
		sut.handle(Coordination.Action.showAppStore)
		
		// Then
		expect(self.urlOpenerSpy.invokedOpen).toEventually(beTrue())
	}
}
