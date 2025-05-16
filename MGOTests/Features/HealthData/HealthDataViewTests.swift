/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class HealthDataViewTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: HealthDataViewModel!
	private var sut: HealthDataView!
	
	override func setUpWithError() throws {
		
		try super.setUpWithError()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		let data = try getResource("multipleValuesMultipleEntries")
		let schema = try HealthUISchema(data: data)
		let healthcareOrganization = Generator.healthcareOrganization("1")
		viewModel = HealthDataViewModel(
			coordinator: coordinatorSpy,
			schema: schema,
			backButtonTitle: "common.previous",
			healthcareOrganization: healthcareOrganization
		)
		sut = HealthDataView(viewModel: self.viewModel)
	}

	func test_HealthCategoryDataView() throws {
		
		// Given
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_backbuttonPressed() throws {
		
		// Given
		let content = NavigationView { sut }
		
		// When
		try content.inspect().find(viewWithAccessibilityIdentifier: "common.previous").button().tap()

		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
}
