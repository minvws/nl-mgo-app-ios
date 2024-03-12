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
	
	func test_coordinatorHandle_actionFinishedLoading_appIntroductionSeen_accessCodeSet_pathShouldContainDashboard() {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedUserHasSeenAppIntroduction = true
		servicesSpies.secureUserSettingsSpy.stubbedAccessCode = "test"
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroductionGetter) == false
		
		// When
		sut.handle(AppCoordination.Action.finishedLoading)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.dashboard])
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
	
	func test_coordinatorHandle_accessCodeConfirmed_noBiometrics_shouldShowDashboard() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .none }
		
		// When
		sut.handle(AppCoordination.Action.accessCodeConfirmed)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.dashboard])
	}
	
	func test_coordinatorHandle_backButtonPressed() {
		
		// Given
		sut.path = NavigationStackBackport.NavigationPath([AppCoordination.State.appIntroduction])
		
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
		expect(self.servicesSpies.notificationCenterSpy.invokedPost) == true
		expect(self.servicesSpies.secureUserSettingsSpy.invokedWipePersistedDataCount) == 1
	}
	
	// MARK: - Views -
	
	func test_coordinatorView_forLaunch() {
		
		// Given
		let state = AppCoordination.State.launch
		
		// When
		let view = sut.view(for: state)
		
		// Then
		assertSnapshot(of: view.frameAsiPhone15Pro(), as: .image(precision: 0.90)) // Lower precision due to random postion of spinner
	}
	
	func test_coordinatorView_forAppIntroduction() {
		
		// Given
		let state = AppCoordination.State.appIntroduction
		
		// When
		let view = sut.view(for: state)
		
		// Then
		assertSnapshot(of: view.frameAsiPhone15Pro(), as: .image)
	}
	
	func test_coordinatorView_forPrivacy() {
		
		// Given
		let state = AppCoordination.State.privacyOverview
		
		// When
		let view = sut.view(for: state)
		
		// Then
		assertSnapshot(of: view.frameAsiPhone15Pro(), as: .image)
	}

	func test_coordinatorView_forPrivacyStatement() {
		
		// Given
		let state = AppCoordination.State.privacyStatement
		
		// When
		let view = sut.view(for: state)
		
		// Then
		assertSnapshot(of: view.frameAsiPhone15Pro(), as: .image)
	}
	
	func test_coordinatorView_forAccessCodeEntry() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .faceID }
		let state = AppCoordination.State.accessCodeEntry
		
		// When
		let view = sut.view(for: state)
		
		// Then
		assertSnapshot(of: view.frameAsiPhone15Pro(), as: .image)
	}
	
	func test_coordinatorView_forAccessCodeConfirmation() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .faceID }
		let state = AppCoordination.State.accessCodeConfirmation
		
		// When
		let view = sut.view(for: state)
		
		// Then
		assertSnapshot(of: view.frameAsiPhone15Pro(), as: .image)
	}
	
	func test_coordinatorView_forBioMetricSetup() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .faceID }
		let state = AppCoordination.State.bioMetricSetup
		
		// When
		let view = sut.view(for: state)
		
		// Then
		assertSnapshot(of: view.frameAsiPhone15Pro(), as: .image)
	}
	
	func test_coordinatorView_forDashboard() {

		// Given
		let state = AppCoordination.State.dashboard
		
		// When
		let view = sut.view(for: state)
		
		// Then
		assertSnapshot(of: view.frameAsiPhone15Pro(), as: .image)
	}
}
