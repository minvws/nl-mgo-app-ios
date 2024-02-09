/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
	
	func test_coordinatorStart_pathShouldContainLaunch() {
		
		// Given
		
		// When
		sut.start()
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.launch])
	}
	
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
	
	func test_coordinatorHandle_actionFinishedLoading_appIntroductionSeen_pathShouldContainDashboard() {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedUserHasSeenAppIntroduction = true
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
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.privacy])
	}
	
	func test_coordinatorHandle_actionNextButtonPressedOnPrivacy_pathShouldContainDashboard_securitySettingsUpdated() {
		
		// Given
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroductionSetter) == false
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroduction) == nil
		
		// When
		sut.handle(AppCoordination.Action.nextButtonPressedOnPrivacy)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.dashboard])
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroductionSetter) == true
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenAppIntroduction) == true
	}
	
	func test_coordinatorHandle_startAndHandle_shouldHaveTwoElements() {
		
		// Given
		
		// When
		sut.start()
		sut.handle(AppCoordination.Action.finishedLoading)
		
		// Then
		expect(self.sut.path.count) == 2
	}
	
	func test_coordinatorHandle_showPrivacyStatementSheet_shouldShowPrivacyStatement() {
		
		// Given
		sut.sheet = nil
		
		// When
		sut.handle(AppCoordination.Action.showPrivacyStatementSheet)
		
		// Then
		expect(self.sut.sheet) == .privacyStatement
	}
	
	func test_coordinatorHandle_dismissPrivacyStatementSheet_shouldDismissPrivacyStatement() {
		
		// Given
		sut.sheet = .privacyStatement
		
		// When
		sut.handle(AppCoordination.Action.dismissPrivacyStatementSheet)
		
		// Then
		expect(self.sut.sheet) == nil
	}
	
	func test_coordinatorView_forLaunch() {
		
		// Given
		let state = AppCoordination.State.launch
		
		// When
		let view = sut.view(for: state)
		
		// Then
		assertSnapshot(of: view.frameAsiPhone15Pro(), as: .image)
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
		let state = AppCoordination.State.privacy
		
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
