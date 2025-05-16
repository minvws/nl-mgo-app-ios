/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
@testable import MGO

final class BioMetricSetupViewModelTests: XCTestCase {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	private var sut: BioMetricSetupViewModel!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		super.setUp()
	}
	
	func setupSut(bioMetricType: () -> LocalAuthentication.BiometricType) {
		
		sut = BioMetricSetupViewModel(coordinator: coordinatorSpy, bioMetricType: bioMetricType)
	}
	
	func test_actionWithoutBioMetrics_shouldCallCoordinator() {
		
		// Given
		setupSut { .faceID }
		
		// When
		sut.reduce(.proceedWithoutBioMetric)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.didFinishLocalAuthentication
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabled).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabledSetter).toEventually(beTrue())
	}
	
	func test_actionWithBioMetrics_authOK_shouldCallCoordinator() {
		
		// Given
		setupSut { .faceID }
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = true
		
		// When
		sut.reduce(.proceedWithBioMetric)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.didFinishLocalAuthentication
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabled).toEventually(beTrue())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabledSetter).toEventually(beTrue())
	}
	
	func test_actionWithBioMetrics_authCancelled_shouldNotCallCoordinator() {
		
		// Given
		setupSut { .faceID }
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		servicesSpies.localAuthenticationProviderSpy.stubbedLocalAuthenticationError = .canceled
		
		// When
		sut.reduce(.proceedWithBioMetric)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabled).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabledSetter).toEventually(beTrue())
	}
	
	func test_actionWithBioMetrics_authFailed_shouldNotCallCoordinator() {
		
		// Given
		setupSut { .faceID }
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		servicesSpies.localAuthenticationProviderSpy.stubbedLocalAuthenticationError = .authenticationFailed
		
		// When
		sut.reduce(.proceedWithBioMetric)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabled).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabledSetter).toEventually(beTrue())
	}
	
	func test_actionWithBioMetrics_authUserFallback_shouldCallCoordinator() {
		
		// Given
		setupSut { .faceID }
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		servicesSpies.localAuthenticationProviderSpy.stubbedLocalAuthenticationError = .userFallback
		
		// When
		sut.reduce(.proceedWithBioMetric)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.didFinishLocalAuthentication
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabled).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabledSetter).toEventually(beTrue())
	}
	
	func test_actionWithBioMetrics_authDeclined_shouldCallCoordinator() {
		
		// Given
		setupSut { .faceID }
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		servicesSpies.localAuthenticationProviderSpy.stubbedLocalAuthenticationError = .declined
		
		// When
		sut.reduce(.proceedWithBioMetric)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.didFinishLocalAuthentication
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabled).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabledSetter).toEventually(beTrue())
	}
	
	func test_actionWithBioMetrics_authLockout_shouldNotCallCoordinator() {
		
		// Given
		setupSut { .faceID }
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		servicesSpies.localAuthenticationProviderSpy.stubbedLocalAuthenticationError = .lockout
		
		// When
		sut.reduce(.proceedWithBioMetric)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabled).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabledSetter).toEventually(beTrue())
		expect(self.sut.state.showLockoutPopup) == true
	}
	
	func test_actionWithBioMetrics_authError_shouldNotCallCoordinator() {
		
		// Given
		setupSut { .faceID }
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		servicesSpies.localAuthenticationProviderSpy.stubbedLocalAuthenticationError = .other(NSError(domain: "test error", code: 12345))
		
		// When
		sut.reduce(.proceedWithBioMetric)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabled).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabledSetter).toEventually(beTrue())
	}
	
	func test_actionShowTouchPopup() {
		
		// Given
		setupSut { .touchID }
		expect(self.sut.state.showTouchPopup) == false
		
		// When
		sut.reduce(.showTouchIDPopup)
		
		// Then
		expect(self.sut.state.showTouchPopup) == true
	}
}
