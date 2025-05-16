/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO

final class AddOrganizationViewModelTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: AddOrganizationViewModel!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		sut = AddOrganizationViewModel(coordinator: coordinatorSpy)
	}

	func test_backButtonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.closeSheet)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.closeSheet
	}
	
	func test_searchButtonPressed_shouldInvokeError() {
		
		// Given
		
		// When
		sut.reduce(.search)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.sut.state.cityError) == "add_organization.error_missing_city"
		expect(self.sut.state.nameError) == "add_organization.error_missing_name"
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(beGreaterThanOrEqualTo(1), timeout: .seconds(5))
	}
	
	func test_searchButtonPressed_cityOK_shouldInvokeError() {
		
		// Given
		sut.state.city = "Den Haag"
		
		// When
		sut.reduce(.search)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.sut.state.cityError) == ""
		expect(self.sut.state.nameError) == "add_organization.error_missing_name"
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(beGreaterThanOrEqualTo(1))
	}
	
	func test_searchButtonPressed_nameOK_shouldInvokeError() {
		
		// Given
		sut.state.name = "Apotheek"
		
		// When
		sut.reduce(.search)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.sut.state.cityError) == "add_organization.error_missing_city"
		expect(self.sut.state.nameError) == ""
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(beGreaterThanOrEqualTo(1))
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
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action(identifier: "showHealthcareOrganizationSearchResults", params: ["city": "Den Haag", "name": "Apotheek"])
	}
	
	func test_searchButtonPressed_cityNotOKnameNotOK_shouldInvokeError() {
		
		// Given
		sut.state.name = "<b></b>"
		sut.state.city = "<script/>"
		
		// When
		sut.reduce(.search)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.sut.state.cityError) == "add_organization.error_missing_city"
		expect(self.sut.state.nameError) == "add_organization.error_missing_name"
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(beGreaterThanOrEqualTo(1))
	}
	
	func test_searchButtonPressed_cityNotOKnameNotOK_whitespacesAndNewlines_shouldInvokeError() {
		
		// Given
		sut.state.name = "<b>    </b>"
		sut.state.city = "      "
		
		// When
		sut.reduce(.search)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.sut.state.cityError) == "add_organization.error_missing_city"
		expect(self.sut.state.nameError) == "add_organization.error_missing_name"
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(beGreaterThanOrEqualTo(1), timeout: .seconds(5))
	}
	
	func test_handleClear_shouldClearCityAndName() {
		
		// Given
		sut.state.name = "Apotheek"
		sut.state.city = "Den Haag"
		
		// When
		sut.reduce(.clear)
		
		// Then
		expect(self.sut.state.city) == ""
		expect(self.sut.state.name) == ""
	}
	
	func test_endEditing() {
		
		// Given
		
		// When
		sut.reduce(.endEditing)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
	}
}
