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

final class SettingsCoordinatorTests: XCTestCase {
	
	private var sut: SettingsCoordinator!
	private var parentCoordinator: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		parentCoordinator = DashboardCoordinatorSpy()
		sut = SettingsCoordinator(parentCoordinator: parentCoordinator)
	}
	
	// MARK: - Handle -
	
	func test_coordinatorHandle_backButtonPressed() {
		
		// Given
		sut.path = NavigationStackBackport.NavigationPath([SettingsCoordination.State.displaySettings])
		
		// When
		sut.handle(Coordination.Action.backButtonPressed)
		
		// Then
		expect(self.sut.path.isEmpty) == true
	}
	
	func test_coordinatorHandle_showDisplaySettings() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.showDisplaySettings)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([SettingsCoordination.State.displaySettings])
	}
	
	func test_coordinatorHandle_showSecuritySettings() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.showSecuritySettings)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([SettingsCoordination.State.securitySettings])
	}
	
	func test_coordinatorHandle_showAdvancedSettings() {
		
		// Given
		
		// When
		sut.handle(Coordination.Action.showAdvancedSettings)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([SettingsCoordination.State.advancedSettings])
	}
}
