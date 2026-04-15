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
	}
	
	@MainActor private func createSut() throws {
		
		let data = try getResource("multipleValuesMultipleEntries")
		let schema = try HealthUISchema(data: data)
		let healthcareOrganization = Generator.healthcareOrganization("1")
		viewModel = HealthDataViewModel(
			coordinator: coordinatorSpy,
			config: HealthDataViewConfig(
				backButtonTitle: "common.previous",
				inSheet: false
			),
			schema: schema,
			healthcareOrganization: healthcareOrganization
		)
		sut = HealthDataView(viewModel: self.viewModel)
	}

	@MainActor func test_view() throws {
		
		// Given
		try createSut()
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
			.environment(\.isPresentedAsSheet, false)
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_view_inSheet() throws {
		
		// Given
		try createSut()
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
			.environment(\.isPresentedAsSheet, true)
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_backbuttonPressed() throws {
		
		// Given
		try createSut()
		let content = NavigationStackBackport.NavigationStack { sut }
			.environment(\.isPresentedAsSheet, false)
		
		// When
		try content.inspect().find(viewWithAccessibilityIdentifier: "common.previous").button().tap()

		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
}
