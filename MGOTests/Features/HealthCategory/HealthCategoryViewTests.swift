/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class HealthCategoryViewTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: HealthCategoryViewModel!
	private var healthcareOrganization: OrganizationSearch.Organization!
	private var sut: HealthCategoryView!

	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1")
	}
	
	@MainActor private func createSut() throws {
		
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: "medication"))
		
		viewModel = HealthCategoryViewModel(
			coordinator: coordinatorSpy,
			category: category,
			organization: healthcareOrganization
		)
		sut = HealthCategoryView(viewModel: self.viewModel)
	}

	@MainActor func test_backbuttonPressed() throws {
		
		// Given
		try createSut()
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// When
		try content.inspect().find(viewWithAccessibilityIdentifier: "common.previous").button().tap()

		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
}
