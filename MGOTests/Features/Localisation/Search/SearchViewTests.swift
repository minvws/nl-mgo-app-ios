/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO
import SwiftUI

final class SearchViewTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: SearchViewModel!
	private var sut: SearchView!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		viewModel = SearchViewModel(coordinator: coordinatorSpy)
		sut = SearchView(viewModel: self.viewModel)
	}

	func test_backbuttonPressed() throws {
		
		// Given
		let content = NavigationView { sut }
		
		// When
		try content.inspect().find(viewWithTag: "back_button").button().tap()

		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
	
	func test_searchView() {
		
		// Given
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_searchView_allFieldsBlank() throws {
		
		// Given
		let content = NavigationView { sut }
		
		// When
		try sut.inspect().find(viewWithTag: "search").button().tap()
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_searchView_nameOK() throws {
		
		// Given
		viewModel.state.name = "Tandarts Tandje Erbij"
		let content = NavigationView { sut }
		
		// When
		try sut.inspect().find(viewWithTag: "search").button().tap()
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_searchView_cityOK() throws {
		
		// Given
		viewModel.state.city = "Roermond"
		let content = NavigationView { sut }
		
		// When
		try sut.inspect().find(viewWithTag: "search").button().tap()
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_searchView_allFieldsOK() throws {
		
		// Given
		viewModel.state.city = "Roermond"
		viewModel.state.name = "Tandarts Tandje Erbij"
		let content = NavigationView { sut }
		
		// When
		try sut.inspect().find(viewWithTag: "search").button().tap()
		
		// Then
		takeSnapShots(content: content)
	}
}
