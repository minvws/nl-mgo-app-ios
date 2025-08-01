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
		super.setUp()
	}
	
	@MainActor private func createSut() {
	
		coordinator = DashboardCoordinator(parentCoordinator: AppCoordinatorSpy())
	}

	@MainActor func test_default() throws {
		
		// Given
		createSut()
		
		// When
		let sut = DashboardCoordinatorView(coordinator: coordinator)
		
		// Then
		takeSnapShots(content: sut, precision: 0.95)
	}
	
	@MainActor func test_secondTab() throws {
		
		// Given
		createSut()
		let sut = DashboardCoordinatorView(coordinator: coordinator)
		
		// When
		coordinator.selectedTab = DashboardTab.healthcareOrganizations.rawValue
		
		// Then
		takeSnapShots(content: sut)
	}
	
	@MainActor func test_thirdTab() throws {
		
		// Given
		createSut()
		let sut = DashboardCoordinatorView(coordinator: coordinator)
		
		// When
		coordinator.selectedTab = DashboardTab.settings.rawValue
		
		// Then
		takeSnapShots(content: sut)
	}
}
