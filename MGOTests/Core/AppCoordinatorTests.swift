/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class AppCoordinatorTests: XCTestCase {
	
	private var sut: AppCoordinator!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		sut = AppCoordinator(path: NavigationStackBackport.NavigationPath())
	}
	
	// MARK: - Handle -
	
	func test_coordinatorHandle_actionFinishedLoading_appIntroductionNotSeen_pathShouldContainAppIntroduction() {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedUserHasSeenAppIntroduction = false
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroductionGetter) == false
		
		// When
		sut.handle(Coordination.Action.finishedLoading)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.appIntroduction(recreated: false)
		expect(self.sut.path.isEmpty) == true
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroductionGetter) == true
	}
	
	func test_coordinatorHandle_actionFinishedLoading_appIntroductionSeen_accessCodeNotSet_pathShouldContainAccesCodeEntry() {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedUserHasSeenAppIntroduction = true
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroductionGetter) == false
		
		// When
		sut.handle(Coordination.Action.finishedLoading)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.accessCodeEntry
		expect(self.sut.path.isEmpty) == true
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroductionGetter) == true
		expect(self.servicesSpies.secureUserSettingsSpy.invokedAccessCodeGetter) == true
	}
	
	func test_coordinatorHandle_actionFinishedLoading_appIntroductionSeen_accessCodeSet_pathShouldContainAccessCodeValidation() {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedUserHasSeenAppIntroduction = true
		servicesSpies.secureUserSettingsSpy.stubbedAccessCode = "test"
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroductionGetter) == false
		
		// When
		sut.handle(Coordination.Action.finishedLoading)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.accessCodeValidation
		expect(self.sut.path.isEmpty) == true
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroductionGetter) == true
	}
	
	func test_coordinatorHandle_actionNextButtonPressedOnAppIntroduction_pathShouldContainPrivacy() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.nextButtonPressedOnAppIntroduction)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.privacyOverview])
	}
	
	func test_coordinatorHandle_actionNextButtonPressedOnPrivacy_pathShouldContainAccessCodeEntry_securitySettingsUpdated() {
		
		// Given
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroductionSetter) == false
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroduction) == nil
		
		// When
		sut.handle(Coordination.Action.nextButtonPressedOnPrivacyOverview)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.accessCodeEntry
		expect(self.sut.path.isEmpty) == true
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroductionSetter) == true
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroduction) == true
	}
	
	func test_coordinatorHandle_showPrivacyStatement_shouldShowPrivacyStatement() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.showPrivacyStatement)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.privacyStatement])
	}
	
	func test_coordinatorHandle_accessCodeEntered_shouldShowAccessCodeConfirmation() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.accessCodeEntered)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.accessCodeConfirmation])
	}

	func test_coordinatorHandle_accessCodeConfirmed_shouldShowBioMetricSetup() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .faceID }
		
		// When
		sut.handle(Coordination.Action.accessCodeConfirmed)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.bioMetricSetup
		expect(self.sut.path.isEmpty) == true
	}
	
	func test_coordinatorHandle_accessCodeConfirmed_noBiometrics_shouldShowRemoteAuthentication() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .none }
		
		// When
		sut.handle(Coordination.Action.accessCodeConfirmed)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.remoteAuthentication
		expect(self.sut.path.isEmpty) == true
	}

	func test_coordinatorHandle_didFinishLocalAuthentication_shouldShowRemoteAuthenciation() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.didFinishLocalAuthentication)
		
		// Then
		expect(self.sut.rootState) == AppCoordination.State.remoteAuthentication
		expect(self.sut.path.isEmpty) == true
	}

	func test_coordinatorHandle_loginWithDigiD_shouldShowDashboard() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.loggedInWithDigiD)
		
		// Then
		expect(self.sut.showChildCoordinator) == true
	}
	
	func test_coordinatorHandle_codeValidated_noHealthcareProviderAdded_shouldShowDashboard() {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedUserHasAddedHealthcareProvider = false
		
		// When
		sut.handle(Coordination.Action.accessCodeValidated)
		
		// Then
		expect(self.sut.showChildCoordinator) == true
	}
	
	func test_coordinatorHandle_codeValidated_healthcareProviderAdded_shouldShowDashboard() {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedUserHasAddedHealthcareProvider = true

		// When
		sut.handle(Coordination.Action.accessCodeValidated)
		
		// Then
		expect(self.sut.showChildCoordinator) == true
	}
	
	func test_coordinatorHandle_forgotAccessCode() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.forgotAccessCode)
		
		// Then
		expect(self.sut.rootStateForSheet) == AppCoordination.State.forgotAccessCode
	}
	
	func test_coordinatorHandle_dismissForgotAccessCode() {
		
		// Given
		sut.rootStateForSheet = AppCoordination.State.forgotAccessCode
		
		// When
		sut.handle(Coordination.Action.dismissForgotAccessCode)
		
		// Then
		expect(self.sut.rootStateForSheet) == nil
	}
	
	func test_coordinatorHandle_recreateAccount_presentInStack() {
		
		// Given
		sut.path = NavigationStackBackport.NavigationPath([AppCoordination.State.remoteAuthentication, AppCoordination.State.accessCodeValidation])
		sut.rootStateForSheet = AppCoordination.State.forgotAccessCode
		
		// When
		sut.handle(Coordination.Action.recreateAccount)
		
		// Then
		expect(self.servicesSpies.secureUserSettingsSpy.invokedWipePersistedData) == true
		expect(self.sut.rootStateForSheet) == nil
		expect(self.sut.rootState) == AppCoordination.State.appIntroduction(recreated: true)
		expect(self.sut.path.isEmpty) == true
	}
	
	func test_coordinatorHandle_backButtonPressed() {
		
		// Given
		sut.path = NavigationStackBackport.NavigationPath([AppCoordination.State.appIntroduction(recreated: false)])
		
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
		sut.path = NavigationStackBackport.NavigationPath([AppCoordination.State.appIntroduction(recreated: false)])
		
		// When
		sut.handle(Coordination.Action.resetApplication)
		
		// Then
		expect(self.sut.path.isEmpty) == true
		expect(self.servicesSpies.notificationCenterSpy.invokedPostName) == true
		expect(self.servicesSpies.secureUserSettingsSpy.invokedWipePersistedDataCount) == 1
		expect(self.servicesSpies.healthcareProviderStoreSpy.invokedWipePersistedDataCount) == 1
	}
}
