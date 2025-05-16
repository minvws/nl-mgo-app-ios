/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class AppCoordinatorStateTests: XCTestCase {
	
	private var sut: AppCoordinator!
	private var servicesSpies: ServicesSpies!
	
	override func setUpWithError() throws {
		
		try super.setUpWithError()
		servicesSpies = setupServicesSpies()
		sut = AppCoordinator(
			path: NavigationStackBackport.NavigationPath()
		)
	}
	
	// MARK: - State -
	
	func test_coordinatorView_forLaunch() throws {
		
		// Given
		let state = AppCoordination.State.splash
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content, precision: 0.90) // Lower precision due to random position of spinner
	}
	
	func test_coordinatorView_forRequiredUpdate() throws {
		
		// Given
		let state = AppCoordination.State.updateRequired
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_coordinatorView_forIntroduction() throws {
		
		// Given
		let state = AppCoordination.State.introduction
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_coordinatorView_forProposition() throws {
		
		// Given
		let state = AppCoordination.State.proposition
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_coordinatorView_forPinCodeEntry() throws {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .faceID }
		let state = AppCoordination.State.pinCodeEntry(backButtonVisible: true)
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_coordinatorView_forPinCodeEntry_withoutBackbutton() throws {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .faceID }
		let state = AppCoordination.State.pinCodeEntry(backButtonVisible: false)
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_coordinatorView_forPinCodeConfirmation() throws {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .faceID }
		let state = AppCoordination.State.pinCodeConfirmation
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_coordinatorView_forPinCodeValidation() throws {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .faceID }
		servicesSpies.secureUserSettingsSpy.stubbedBioMetricAuthenticationEnabled = true
		let state = AppCoordination.State.pinCodeValidation(lockOut: false)
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_coordinatorView_forBioMetricSetup() throws {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .faceID }
		let state = AppCoordination.State.bioMetricSetup
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_coordinatorView_forLogin() throws {
		
		// Given
		let state = AppCoordination.State.login
		servicesSpies.secureUserSettingsSpy.stubbedUserHasRemoteAuthentication = true
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_coordinatorView_forLoginInfo() throws {
		
		// Given
		let state = AppCoordination.State.loginInfo
		servicesSpies.secureUserSettingsSpy.stubbedUserHasRemoteAuthentication = true
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_coordinatorView_forgotPinCode() throws {
		
		// Given
		let state = AppCoordination.State.forgotPinCode
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_coordinatorView_accountRemoved() throws {
		
		// Given
		let state = AppCoordination.State.accountRemoved
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_coordinatorView_forDashboard() throws {
		
		// Given
		let state = AppCoordination.State.dashboard
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	func test_coordinatorView_forAutomaticLocalization() throws {
		
		// Given
		let state = AppCoordination.State.automaticLocalization
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	func test_coordinatorView_forManualLocalization() throws {
		
		// Given
		let state = AppCoordination.State.manualLocalization
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	func test_coordinatorView_forHealthcareOrganizationSearchResults() throws {
		
		// Given
		let state = AppCoordination.State.healthcareOrganizationSearchResults(city: "Roermond", name: "Tandarts Tandje Erbij")
		stub(condition: isPath("/localization/organization/search")) { _ in
			return HTTPStubsResponse(data: Data(), statusCode: 200, headers: nil)
		}
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
}
