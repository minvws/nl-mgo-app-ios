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
	
	func test_list() {
		
		// Given
		createSut()
		let list = [
			generateHealthcareProvider("1"),
			generateHealthcareProvider("2"),
			generateHealthcareProvider("3"),
			generateHealthcareProvider("4", city: "", address: "", postalCode: "")
		]
		viewModel.state = .success(list)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	// MARK: - helper methods -
	
	private func generateHealthcareProvider(_ id: String, city: String = "Roermond", address: String = "Boorplatform 5", postalCode: String = "1234AB") -> HealthcareProvider {
		return HealthcareProvider(
			display_name: "Tandarts Tandje Erbij",
			   identification_type: "type",
			   identification_value: id,
			   active: true,
			   addresses: [Components.Schemas.Address(
				   active: true,
				   address: address,
				   city: city,
				   postalcode: postalCode,
				   _type: "postal")
			   ],
			   names: [],
			   types: []
		   )
	}
}
