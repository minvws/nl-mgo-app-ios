/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO
import LocalisationServiceClient
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
	
	func test_list() {
		
		// Given
		createSut()
		let list = [
			SearchResult(id: "1", name: "Tandarts Tandje Erbij", city: "Roermond", address: "Boorplatform 5", postalCode: "1234AB"),
			SearchResult(id: "2", name: "Tandarts Tandje Erbij", city: "Roermond", address: "Boorplatform 5", postalCode: "1234AB"),
			SearchResult(id: "3", name: "Tandarts Tandje Erbij", city: "Roermond", address: "Boorplatform 5", postalCode: "1234AB"),
			SearchResult(id: "4", name: "Tandarts Tandje Erbij", city: nil, address: nil, postalCode: nil)
		]
		viewModel.state = .success(list)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
