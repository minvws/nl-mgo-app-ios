/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO
import MGOFoundation
import MGOUI

final class SearchResultViewTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var localisationServiceClientSpy: LocalisationServiceClientSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: SearchResultsViewModel!
	private var sut: SearchResultsView!

	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		localisationServiceClientSpy = LocalisationServiceClientSpy()
	}
	
	private func createSut(city: String = "Roermond", name: String = "Tandarts Tandje Erbij") {
		
		viewModel = SearchResultsViewModel(coordinator: coordinatorSpy, city: city, name: name, localisationServiceClient: localisationServiceClientSpy)
		sut = SearchResultsView(viewModel: self.viewModel)
	}

	func test_loading() {
		
		// Given
		createSut()
		viewModel.state = .loading
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_backbuttonPressed() throws {
		
		// Given
		createSut()
		viewModel.state = .loading
		let content = NavigationView { sut }
		
		// When
		try content.inspect().find(viewWithTag: "back_button").button().tap()

		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
	
	func test_empty() {
		
		// Given
		createSut()
		viewModel.state = .empty(city: "Roermond", name: "Tandarts Tandje Erbij")

		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_empty_action() throws {
		
		// Given
		createSut()
		viewModel.state = .empty(city: "Roermond", name: "Tandarts Tandje Erbij")
		
		// When
		try sut.inspect().find(viewWithTag: "action_button").button().tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backToAddHealthcareOrganization
		expect(self.servicesSpies.notificationCenterSpy.invokedPostName) == true
	}

	func test_failure() {
		
		// Given
		createSut()
		let error = NSError(domain: "SearchResultViewModelTests", code: 404)
		viewModel.state = .failure(error)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_failure_action() throws {
		
		// Given
		createSut()
		let error = NSError(domain: "SearchResultViewModelTests", code: 404)
		viewModel.state = .failure(error)
		
		// When
		try sut.inspect().find(viewWithTag: "action_button").button().tap()
		
		// Then
		expect(self.viewModel.state).toEventually(equal(.empty(city: "Roermond", name: "Tandarts Tandje Erbij")))
		expect(self.localisationServiceClientSpy.invokedSearchHealthcareProviders).toEventually(beTrue())
	}
	
	func test_list_lightPortrait() {
		
		// Given
		createSut()
		let list: [SearchResultSet] = [
			((Generator.healthcareProvider("1"), SearchResultCardState.regular)),
			((Generator.healthcareProvider("2"), SearchResultCardState.warning)),
			((Generator.healthcareProvider("3"), SearchResultCardState.selected)),
			((Generator.healthcareProvider("4", city: "", address: "", postalCode: ""), SearchResultCardState.regular))
		]
		viewModel.state = .success(list)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.light)),
			as: .image(on: .iPhone15Pro(.portrait), precision: 1.0)
		)
	}
	
	func test_list_darkPortrait() {
		
		// Given
		createSut()
		let list: [SearchResultSet] = [
			((Generator.healthcareProvider("1"), SearchResultCardState.regular)),
			((Generator.healthcareProvider("2"), SearchResultCardState.warning)),
			((Generator.healthcareProvider("3"), SearchResultCardState.selected)),
			((Generator.healthcareProvider("4", city: "", address: "", postalCode: ""), SearchResultCardState.regular))
		]
		viewModel.state = .success(list)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.dark)),
			as: .image(on: .iPhone15Pro(.portrait), precision: 1.0)
		)
	}
	
	func test_list_lightLandscape() {
		
		// Given
		createSut()
		let list: [SearchResultSet] = [
			((Generator.healthcareProvider("1"), SearchResultCardState.regular)),
			((Generator.healthcareProvider("2"), SearchResultCardState.warning)),
			((Generator.healthcareProvider("3"), SearchResultCardState.selected)),
			((Generator.healthcareProvider("4", city: "", address: "", postalCode: ""), SearchResultCardState.regular))
		]
		viewModel.state = .success(list)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.light)),
			as: .image(on: .iPhone15Pro(.landscape), precision: 1.0)
		)
	}
	
	func test_list_darkLandscape() {
		
		// Given
		createSut()
		let list: [SearchResultSet] = [
			((Generator.healthcareProvider("1"), SearchResultCardState.regular)),
			((Generator.healthcareProvider("2"), SearchResultCardState.warning)),
			((Generator.healthcareProvider("3"), SearchResultCardState.selected)),
			((Generator.healthcareProvider("4", city: "", address: "", postalCode: ""), SearchResultCardState.regular))
		]
		viewModel.state = .success(list)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.dark)),
			as: .image(on: .iPhone15Pro(.landscape), precision: 1.0)
		)
	}
}
