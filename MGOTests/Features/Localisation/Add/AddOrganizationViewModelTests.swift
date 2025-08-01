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
	}
	
	@MainActor private func createSut() {
		
		sut = AddOrganizationViewModel(coordinator: coordinatorSpy)
	}
	
	@MainActor func test_backButtonPressed_shouldCallCoordinator() {
		
		// Given
		createSut()
		
		// When
		sut.reduce(.closeSheet)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.closeSheet
	}
	
	@MainActor func test_searchButtonPressed_shouldInvokeError() {
		
		// Given
		createSut()
		
		// When
		sut.reduce(.search)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.sut.state.cityError) == "add_organization.error_missing_city"
		expect(self.sut.state.nameError) == "add_organization.error_missing_name"
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(beGreaterThanOrEqualTo(1), timeout: .seconds(5))
	}
	
	@MainActor func test_searchButtonPressed_cityOK_shouldInvokeError() {
		
		// Given
		createSut()
		sut.state.city = "Den Haag"
		
		// When
		sut.reduce(.search)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.sut.state.cityError) == ""
		expect(self.sut.state.nameError) == "add_organization.error_missing_name"
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(beGreaterThanOrEqualTo(1))
	}
	
	@MainActor func test_searchButtonPressed_nameOK_shouldInvokeError() {
		
		// Given
		createSut()
		sut.state.name = "Apotheek"
		
		// When
		sut.reduce(.search)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.sut.state.cityError) == "add_organization.error_missing_city"
		expect(self.sut.state.nameError) == ""
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(beGreaterThanOrEqualTo(1))
	}
	
	@MainActor func test_searchButtonPressed_cityOKnameOK_shouldInvokeError() {
		
		// Given
		createSut()
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
	
	@MainActor func test_searchButtonPressed_cityNotOKnameNotOK_shouldInvokeError() {
		
		// Given
		createSut()
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
	
	@MainActor func test_searchButtonPressed_cityNotOKnameNotOK_whitespacesAndNewlines_shouldInvokeError() {
		
		// Given
		createSut()
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
	
	@MainActor func test_handleClear_shouldClearCityAndName() {
		
		// Given
		createSut()
		sut.state.name = "Apotheek"
		sut.state.city = "Den Haag"
		
		// When
		sut.reduce(.clear)
		
		// Then
		expect(self.sut.state.city) == ""
		expect(self.sut.state.name) == ""
	}
	
	@MainActor func test_endEditing() {
		
		// Given
		createSut()
		
		// When
		sut.reduce(.endEditing)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
	}
}
