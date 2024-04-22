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
		sut.handle(AppCoordination.Action.finishedLoading)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.appIntroduction])
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroductionGetter) == true
	}
	
	func test_coordinatorHandle_actionFinishedLoading_appIntroductionSeen_accessCodeNotSet_pathShouldContainAccesCodeEntry() {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedUserHasSeenAppIntroduction = true
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroductionGetter) == false
		
		// When
		sut.handle(AppCoordination.Action.finishedLoading)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.accessCodeEntry])
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroductionGetter) == true
		expect(self.servicesSpies.secureUserSettingsSpy.invokedAccessCodeGetter) == true
	}
	
	func test_coordinatorHandle_actionFinishedLoading_appIntroductionSeen_accessCodeSet_pathShouldContainAccessCodeValidation() {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedUserHasSeenAppIntroduction = true
		servicesSpies.secureUserSettingsSpy.stubbedAccessCode = "test"
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroductionGetter) == false
		
		// When
		sut.handle(AppCoordination.Action.finishedLoading)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.accessCodeValidation])
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroductionGetter) == true
	}
	
	func test_coordinatorHandle_actionNextButtonPressedOnAppIntroduction_pathShouldContainPrivacy() {
		
		// Given
		
		// When
		sut.handle(AppCoordination.Action.nextButtonPressedOnAppIntroduction)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.privacyOverview])
	}
	
	func test_coordinatorHandle_actionNextButtonPressedOnPrivacy_pathShouldContainAccessCodeEntry_securitySettingsUpdated() {
		
		// Given
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroductionSetter) == false
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroduction) == nil
		
		// When
		sut.handle(AppCoordination.Action.nextButtonPressedOnPrivacyOverview)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.accessCodeEntry])
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroductionSetter) == true
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroduction) == true
	}
	
	func test_coordinatorHandle_showPrivacyStatement_shouldShowPrivacyStatement() {
		
		// Given
		
		// When
		sut.handle(AppCoordination.Action.showPrivacyStatement)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.privacyStatement])
	}
	
	func test_coordinatorHandle_accessCodeEntered_shouldShowAccessCodeConfirmation() {
		
		// Given
		
		// When
		sut.handle(AppCoordination.Action.accessCodeEntered)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.accessCodeConfirmation])
	}

	func test_coordinatorHandle_accessCodeConfirmed_shouldShowBioMetricSetup() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .faceID }
		
		// When
		sut.handle(AppCoordination.Action.accessCodeConfirmed)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.bioMetricSetup])
	}
	
	func test_coordinatorHandle_accessCodeConfirmed_noBiometrics_shouldShowRemoteAuthentication() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .none }
		
		// When
		sut.handle(AppCoordination.Action.accessCodeConfirmed)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.remoteAuthentication])
	}

	func test_coordinatorHandle_didFinishLocalAuthentication_shouldShowRemoteAuthenciation() {
		
		// Given
		
		// When
		sut.handle(AppCoordination.Action.didFinishLocalAuthentication)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.remoteAuthentication])
	}

	func test_coordinatorHandle_loginWithDigiD_shouldShowDashboard() {
		
		// Given
		
		// When
		sut.handle(AppCoordination.Action.loginWithDigiD)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.dashboard])
	}

	func test_coordinatorHandle_loginWithAccessCode_shouldShowAccessCodeValidation() {
		
		// Given
		
		// When
		sut.handle(AppCoordination.Action.loginWithAccessCode)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.accessCodeValidation])
	}
	
	func test_coordinatorHandle_codeValidated_shouldShowDashboard() {
		
		// Given
		
		// When
		sut.handle(AppCoordination.Action.accessCodeValidated)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.dashboard])
	}
	
	func test_coordinatorHandle_forgotAccessCode() {
		
		// Given
		
		// When
		sut.handle(AppCoordination.Action.forgotAccessCode)
		
		// Then
		expect(self.sut.sheet) == AppCoordination.State.forgotAccessCode
	}
	
	func test_coordinatorHandle_dismissForgotAccessCode() {
		
		// Given
		sut.sheet = AppCoordination.State.forgotAccessCode
		
		// When
		sut.handle(AppCoordination.Action.dismissForgotAccessCode)
		
		// Then
		expect(self.sut.sheet) == nil
	}
	
	func test_coordinatorHandle_recreateAccount_presentInStack() {
		
		// Given
		sut.path = NavigationStackBackport.NavigationPath([AppCoordination.State.remoteAuthentication, AppCoordination.State.accessCodeValidation])
		sut.sheet = AppCoordination.State.forgotAccessCode
		
		// When
		sut.handle(AppCoordination.Action.recreateAccount)
		
		// Then
		expect(self.servicesSpies.secureUserSettingsSpy.invokedWipePersistedData) == true
		expect(self.sut.sheet) == nil
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.accessCodeEntry])
		expect(self.sut.path.count) == 1
	}
	
	func test_coordinatorHandle_backButtonPressed() {
		
		// Given
		sut.path = NavigationStackBackport.NavigationPath([AppCoordination.State.appIntroduction])
		
		// When
		sut.handle(AppCoordination.Action.backButtonPressed)
		
		// Then
		expect(self.sut.path.isEmpty) == true
	}
	
	func test_coordinatorHandle_backButtonPressed_emptyPath() {
		
		// Given
		sut.path = NavigationStackBackport.NavigationPath()
		
		// When
		sut.handle(AppCoordination.Action.backButtonPressed)
		
		// Then
		expect(self.sut.path.isEmpty) == true
	}
	
	func test_coordinatorHandle_resetApplication() {
		
		// Given
		sut.path = NavigationStackBackport.NavigationPath([AppCoordination.State.appIntroduction])
		
		// When
		sut.handle(AppCoordination.Action.resetApplication)
		
		// Then
		expect(self.sut.path.isEmpty) == true
		expect(self.servicesSpies.notificationCenterSpy.invokedPostName) == true
		expect(self.servicesSpies.secureUserSettingsSpy.invokedWipePersistedDataCount) == 1
	}
	
	func test_coordinatorHandle_poc() {
		
		// Given
		
		// When
		sut.handle(AppCoordination.Action.fhirClient)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.fhirClient])
	}
	
	func test_coordinatorHandle_searchHealthcareProviders() {
		
		// Given
		
		// When
		sut.handle(AppCoordination.Action.searchHealthcareProviders)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.searchHealthcareProvider])
	}
	
	func test_coordinatorHandle_search() {
		
		// Given
		
		// When
		sut.handle(AppCoordination.Action.search(city: "Roermond", name: "Tandarts Tandje Erbij"))
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.searchHealthcareProviders(city: "Roermond", name: "Tandarts Tandje Erbij")])
	}
}
