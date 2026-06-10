/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
import MGOUI
@testable import MGO

final class HealthcareCoordinatorViewTests: XCTestCase {
	
	private var coordinator: HealthcareCoordinator!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		servicesSpies = setupServicesSpies()
		coordinator = HealthcareCoordinator(
			parentCoordinator: DashboardCoordinatorSpy(),
			rootState: .organizations
		)
		super.setUp()
	}
	
	@MainActor func test_default() throws {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = []
		
		// When
		let sut = HealthcareCoordinatorView(coordinator: coordinator)
		
		// Then
		_ = try sut.inspect().find(viewWithAccessibilityIdentifier: "common.add_organizations")
	}
}
