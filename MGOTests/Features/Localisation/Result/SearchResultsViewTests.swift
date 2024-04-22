/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO
import LocalisationServiceClient

final class SearchResultViewTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var localisationServiceClientSpy: LocalisationServiceClientSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: SearchResultViewModel!

	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		localisationServiceClientSpy = LocalisationServiceClientSpy()
	}
	
	private func createSut(city: String = "Roermond", name: String = "Tandarts Tandje Erbij") {
		
		viewModel = SearchResultViewModel(coordinator: coordinatorSpy, city: city, name: name, localisationServiceClient: localisationServiceClientSpy)
		sut = SearchResultView(viewModel: viewModel)
	}

	func test_loading() {
		
		// Given
		createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)

	func test_empty() {
		
		// Given
		createSut()
		localisationServiceClientSpy.stubbedSearchHealthcareProviders = []
		sut.reduce(.onAppear)

		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}

	func test_failure() {
		
		// Given
		createSut()
		let error = NSError(domain: "SearchResultViewModelTests", code: 404)
		localisationServiceClientSpy.stubbedSearchHealthcareProviderError = error
		sut.reduce(.onAppear)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_list() {
		
		// Given
		createSut()
		let list: [Components.Schemas.Organization] = [
			Components.Schemas.Organization(
				display_name: "Tandarts Tandje Erbij",
				identification_type: "type",
				identification_value: "value",
				active: true,
				addresses: [Components.Schemas.Address(
					active: true,
					address: "Boorplatform 5",
					city: "Roermond",
					postalcode: "1234AB",
					_type: "postal")
				],
				names: [],
				types: []
			)
		]
		localisationServiceClientSpy.stubbedSearchHealthcareProviders = list
		sut.reduce(.onAppear)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
