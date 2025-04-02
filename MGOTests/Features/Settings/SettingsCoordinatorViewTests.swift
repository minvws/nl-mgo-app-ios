/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
import MGOUI
@testable import MGO

final class SettingsCoordinatorViewTests: XCTestCase {
	
	private var coordinator: SettingsCoordinator!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		servicesSpies = setupServicesSpies()
		coordinator = SettingsCoordinator(parentCoordinator: DashboardCoordinatorSpy())
		super.setUp()
	}

	func test_default() throws {
		
		// Given
		
		// When
		let sut = SettingsCoordinatorView(coordinator: coordinator)
		
		// Then
		takeSnapShots(content: sut)
	}
}
