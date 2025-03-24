/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class SettingsCoordinatorStateTests: XCTestCase {
	
	private var sut: SettingsCoordinator!
	private var parentCoordinator: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		parentCoordinator = DashboardCoordinatorSpy()
		sut = SettingsCoordinator(parentCoordinator: parentCoordinator)
	}
	
	func test_coordinatorView_forSettings() throws {
		
		// Given
		let state = SettingsCoordination.State.settings
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forSettings_noBiometricType() throws {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .none }
		let state = SettingsCoordination.State.settings
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forDisplaySettings() throws {
		
		// Given
		let state = SettingsCoordination.State.displaySettings
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forSecuritySettings() throws {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .faceID }
		let state = SettingsCoordination.State.securitySettings
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forAdvancedSettings() throws {
		
		// Given
		let state = SettingsCoordination.State.advancedSettings
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
}
