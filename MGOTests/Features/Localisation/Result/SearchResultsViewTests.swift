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
	private var viewModel: SearchResultViewModel!
	private var sut: SearchResultView!

	override func setUp() {

		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		localisationServiceClientSpy = LocalisationServiceClientSpy()
	}
	
	private func createSut(city: String = "Roermond", name: String = "Tandarts Tandje Erbij") {
		
		viewModel = SearchResultViewModel(coordinator: coordinatorSpy, city: city, name: name, localisationServiceClient: localisationServiceClientSpy)
		sut = SearchResultView(viewModel: self.viewModel)
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
	
	func test_empty() {
		
		// Given
		createSut()
		viewModel.state = .empty(city: "Roermond", name: "Tandarts Tandje Erbij")

		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
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
	
	func test_list_lightPortrait() {
		
		// Given
		createSut()
		let list: [SearchResultSet] = [
			((Generator.healthcareProvider("1"), SearchResultCardState.regular)),
			((Generator.healthcareProvider("2"), SearchResultCardState.regular)),
			((Generator.healthcareProvider("3"), SearchResultCardState.regular)),
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
			((Generator.healthcareProvider("2"), SearchResultCardState.regular)),
			((Generator.healthcareProvider("3"), SearchResultCardState.regular)),
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
			((Generator.healthcareProvider("2"), SearchResultCardState.regular)),
			((Generator.healthcareProvider("3"), SearchResultCardState.regular)),
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
			((Generator.healthcareProvider("2"), SearchResultCardState.regular)),
			((Generator.healthcareProvider("3"), SearchResultCardState.regular)),
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
