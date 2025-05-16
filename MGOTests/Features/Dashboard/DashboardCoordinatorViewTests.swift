/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
import MGOUI
@testable import MGO

final class DashboardCoordinatorViewTests: XCTestCase {
	
	private var coordinator: DashboardCoordinator!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		servicesSpies = setupServicesSpies()
		coordinator = DashboardCoordinator(parentCoordinator: AppCoordinatorSpy())
		super.setUp()
	}

	func test_default() throws {
		
		// Given
		
		// When
		let sut = DashboardCoordinatorView(coordinator: coordinator)
		
		// Then
		takeSnapShots(content: sut, precision: 0.95)
	}
	
	func test_secondTab() throws {
		
		// Given
		let sut = DashboardCoordinatorView(coordinator: coordinator)
		
		// When
		coordinator.selectedTab = DashboardTab.healthcareOrganizations.rawValue
		
		// Then
		takeSnapShots(content: sut)
	}
	
	func test_thirdTab() throws {
		
		// Given
		let sut = DashboardCoordinatorView(coordinator: coordinator)
		
		// When
		coordinator.selectedTab = DashboardTab.settings.rawValue
		
		// Then
		takeSnapShots(content: sut)
	}
}
