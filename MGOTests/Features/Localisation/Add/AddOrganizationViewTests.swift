/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOUI
@testable import MGO
import MGOFoundation

final class AddOrganizationViewTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: AddOrganizationViewModel!
	private var sut: AddOrganizationView!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
	}
	
	@MainActor private func createSut() {
		
		viewModel = AddOrganizationViewModel(coordinator: coordinatorSpy)
		sut = AddOrganizationView(viewModel: self.viewModel)
	}
	
	@MainActor func test_addOrganizationView() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		createSut()
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut.isPresentedAsSheet(false) }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_addOrganizationView_iOS18() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		createSut()
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut.isPresentedAsSheet(false) }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_addOrganizationView_isPresentedAsSheet() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		createSut()
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut.isPresentedAsSheet(true) }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	@MainActor func test_addOrganizationView_allFieldsBlank() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		createSut()
		let content = NavigationStackBackport.NavigationStack { sut.isPresentedAsSheet(false) }
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "common.search")
		try view.view(CallToActionButton.self).find(button: "common.search").tap()
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_addOrganizationView_nameOK() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		createSut()
		viewModel.state.name = "Tandarts Tandje Erbij"
		let content = NavigationStackBackport.NavigationStack { sut.isPresentedAsSheet(false) }
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "common.search")
		try view.view(CallToActionButton.self).find(button: "common.search").tap()
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_addOrganizationView_cityOK() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		createSut()
		viewModel.state.city = "Roermond"
		let content = NavigationStackBackport.NavigationStack { sut.isPresentedAsSheet(false) }
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "common.search")
		try view.view(CallToActionButton.self).find(button: "common.search").tap()
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_addOrganizationView_allFieldsOK() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		createSut()
		viewModel.state.city = "Roermond"
		viewModel.state.name = "Tandarts Tandje Erbij"
		let content = NavigationStackBackport.NavigationStack { sut.isPresentedAsSheet(false) }
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "common.search")
		try view.view(CallToActionButton.self).find(button: "common.search").tap()
		
		// Then
		takeSnapShots(content: content)
	}
}
