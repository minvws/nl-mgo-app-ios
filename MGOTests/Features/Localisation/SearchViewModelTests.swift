/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO

final class SearchViewModelTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: SearchViewModel!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		sut = SearchViewModel(coordinator: coordinatorSpy)
	}

	func test_backButtonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == AppCoordination.Action.backButtonPressed
	}
	
	func test_searchButtonPressed_shouldInvokeError() {
		
		// Given
		
		// When
		sut.reduce(.search)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.sut.state.cityError) == "searchhp_city_error"
		expect(self.sut.state.nameError) == "searchhp_name_error"
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(equal(1))
	}
	
	func test_searchButtonPressed_cityOK_shouldInvokeError() {
		
		// Given
		sut.state.city = "Den Haag"
		
		// When
		sut.reduce(.search)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.sut.state.cityError) == ""
		expect(self.sut.state.nameError) == "searchhp_name_error"
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(equal(1))
	}
	
	func test_searchButtonPressed_nameOK_shouldInvokeError() {
		
		// Given
		sut.state.name = "Apotheek"
		
		// When
		sut.reduce(.search)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.sut.state.cityError) == "searchhp_city_error"
		expect(self.sut.state.nameError) == ""
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(equal(1))
	}
	
	func test_searchButtonPressed_cityOKnameOK_shouldInvokeError() {
		
		// Given
		sut.state.name = "Apotheek"
		sut.state.city = "Den Haag"
		
		// When
		sut.reduce(.search)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.sut.state.cityError) == ""
		expect(self.sut.state.nameError) == ""
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == AppCoordination.Action.search(city: "Den Haag", name: "Apotheek")
	}
	
	func test_searchButtonPressed_cityNotOKnameNotOK_shouldInvokeError() {
		
		// Given
		sut.state.name = "<b></b>"
		sut.state.city = "<script/>"
		
		// When
		sut.reduce(.search)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.sut.state.cityError) == "searchhp_city_error"
		expect(self.sut.state.nameError) == "searchhp_name_error"
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(equal(1))
	}
}
