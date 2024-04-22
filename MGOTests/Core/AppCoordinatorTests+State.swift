/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
import LocalisationServiceClient
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
	
	func test_coordinatorView_forAppIntroduction() throws {
		
		// Given
		let state = AppCoordination.State.appIntroduction
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forPrivacyOverview() throws {
		
		// Given
		let state = AppCoordination.State.privacyOverview
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forAccessCodeEntry() throws {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .faceID }
		let state = AppCoordination.State.accessCodeEntry
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forAccessCodeConfirmation() throws {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .faceID }
		let state = AppCoordination.State.accessCodeConfirmation
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forAccessCodeValidation() throws {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .faceID }
		servicesSpies.secureUserSettingsSpy.stubbedBioMetricAuthenticationEnabled = true
		let state = AppCoordination.State.accessCodeValidation
		
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

	func test_coordinatorView_forRemoteAuthentication_firstVisit() throws {

		// Given
		let state = AppCoordination.State.remoteAuthentication
		servicesSpies.secureUserSettingsSpy.stubbedUserHasRemoteAuthentication = false
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forRemoteAuthentication_repeatVisit() throws {

		// Given
		let state = AppCoordination.State.remoteAuthentication
		servicesSpies.secureUserSettingsSpy.stubbedUserHasRemoteAuthentication = true
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forgotAccessCode() throws {
		
		// Given
		let state = AppCoordination.State.forgotAccessCode
		
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
	
	func test_coordinatorView_forfhirClient() throws {

		// Given
		let state = AppCoordination.State.fhirClient
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forSearch() throws {

		// Given
		let state = AppCoordination.State.searchHealthcareProvider
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forSearchResults() throws {

		// Given
		let state = AppCoordination.State.searchHealthcareProviders(city: "Roermond", name: "Tandarts Tandje Erbij")
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
}
