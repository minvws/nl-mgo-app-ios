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

final class AppCoordinatorStateTests: XCTestCase {
	
	private var sut: AppCoordinator!
	private var servicesSpies: ServicesSpies!
	private var localisationServiceClientSpy: LocalisationServiceClientSpy!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		localisationServiceClientSpy = LocalisationServiceClientSpy()
		localisationServiceClientSpy.stubbedSearchHealthcareProviders = []
		sut = AppCoordinator(
			path: NavigationStackBackport.NavigationPath(),
			localisationServiceClient: localisationServiceClientSpy
		)
	}
	
	// MARK: - State -
	
	func test_coordinatorView_forLaunch() throws {
		
		// Given
		let state = AppCoordination.State.launch
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view), precision: 0.90) // Lower precision due to random postion of spinner
	}
	
	func test_coordinatorView_forIntroduction_recreatedFalse() throws {
		
		// Given
		let state = AppCoordination.State.introduction(recreated: false)
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forIntroduction_recreatedTrue() throws {
		
		// Given
		let state = AppCoordination.State.introduction(recreated: true)
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forProposition() throws {
		
		// Given
		let state = AppCoordination.State.proposition
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forPinCodeEntry() throws {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .faceID }
		let state = AppCoordination.State.pinCodeEntry
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forPinCodeConfirmation() throws {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .faceID }
		let state = AppCoordination.State.pinCodeConfirmation
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forPinCodeValidation() throws {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .faceID }
		servicesSpies.secureUserSettingsSpy.stubbedBioMetricAuthenticationEnabled = true
		let state = AppCoordination.State.pinCodeValidation
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forBioMetricSetup() throws {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .faceID }
		let state = AppCoordination.State.bioMetricSetup
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}

	func test_coordinatorView_forLogin_firstVisit() throws {
		
		// Given
		let state = AppCoordination.State.login
		servicesSpies.secureUserSettingsSpy.stubbedUserHasRemoteAuthentication = false
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forLogin_repeatVisit() throws {

		// Given
		let state = AppCoordination.State.login
		servicesSpies.secureUserSettingsSpy.stubbedUserHasRemoteAuthentication = true
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forgotPinCode() throws {
		
		// Given
		let state = AppCoordination.State.forgotPinCode
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forDashboard() throws {
		
		// Given
		let state = AppCoordination.State.dashboard
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
}
