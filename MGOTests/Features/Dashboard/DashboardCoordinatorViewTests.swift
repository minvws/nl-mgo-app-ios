/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
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
		takeSnapShots(content: sut)
	}
}
