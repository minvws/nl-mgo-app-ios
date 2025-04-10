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

final class DashboardCoordinatorTests: XCTestCase {
	
	private var sut: DashboardCoordinator!
	private var parentCoordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		servicesSpies = setupServicesSpies()
		parentCoordinatorSpy = AppCoordinatorSpy()
		sut = DashboardCoordinator(parentCoordinator: parentCoordinatorSpy)
		super.setUp()
	}

	func test_handleResetApplication() throws {
		
		// Given
		
		// When
		sut.handle(.resetApplication)
		
		// Then
		expect(self.parentCoordinatorSpy.invokedHandle) == true
		expect(self.parentCoordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.resetApplication
	}
}
