/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOUI
@testable import MGO

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
		createSut()
		
		// When
		let content = NavigationView { sut.isPresentedAsSheet(false) }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_addOrganizationView_isPresentedAsSheet() {
		
		// Given
		createSut()
		
		// When
		let content = NavigationView { sut.isPresentedAsSheet(true) }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	@MainActor func test_addOrganizationView_allFieldsBlank() throws {
		
		// Given
		createSut()
		let content = NavigationView { sut.isPresentedAsSheet(false) }
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "common.search")
		try view.view(CallToActionButton.self).find(button: "common.search").tap()
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_addOrganizationView_nameOK() throws {
		
		// Given
		createSut()
		viewModel.state.name = "Tandarts Tandje Erbij"
		let content = NavigationView { sut.isPresentedAsSheet(false) }
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "common.search")
		try view.view(CallToActionButton.self).find(button: "common.search").tap()
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_addOrganizationView_cityOK() throws {
		
		// Given
		createSut()
		viewModel.state.city = "Roermond"
		let content = NavigationView { sut.isPresentedAsSheet(false) }
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "common.search")
		try view.view(CallToActionButton.self).find(button: "common.search").tap()
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_addOrganizationView_allFieldsOK() throws {
		
		// Given
		createSut()
		viewModel.state.city = "Roermond"
		viewModel.state.name = "Tandarts Tandje Erbij"
		let content = NavigationView { sut.isPresentedAsSheet(false) }
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "common.search")
		try view.view(CallToActionButton.self).find(button: "common.search").tap()
		
		// Then
		takeSnapShots(content: content)
	}
}
