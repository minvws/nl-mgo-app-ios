/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO
import Zibs

final class HealthCategoryDataViewTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: HealthCategoryDataViewModel!
	private var sut: HealthCategoryDataView!
	
	override func setUpWithError() throws {
		
		try super.setUpWithError()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		let data = try getResource("multipleValuesMultipleEntries")
		let schema = try UISchema(data: data)
		viewModel = HealthCategoryDataViewModel(coordinator: coordinatorSpy, title: "test_HealthCategoryDataView", schema: schema)
		sut = HealthCategoryDataView(viewModel: self.viewModel)
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
