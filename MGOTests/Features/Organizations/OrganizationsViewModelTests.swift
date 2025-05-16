/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO
import MGOFoundation
import MGOUI

final class OrganizationsViewModelTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: OrganizationsViewModel!

	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		
		sut = OrganizationsViewModel(coordinator: coordinatorSpy)
	}

	func test_onAppear_shouldCallStore_noOrganzations_stateShouldBeEmtpy() {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = []
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedOrganizationsGetter) == true
		expect(self.sut.state) == .empty
	}
	
	func test_onAppear_shouldCallStore_withOrganizations_stateShouldBeList() {
		
		// Given
		let healthcareOrganization = Generator.healthcareOrganization("1")
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedOrganizationsGetter) == true
		expect(self.sut.state) == .list([healthcareOrganization])
	}
	
	func test_searchButtonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.search)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.addHealthcareOrganization
	}
	
	func test_detailsButtonPressed_shouldCallCoordinator() {
		
		// Given
		let healthcareOrganization = Generator.healthcareOrganization("1")
		
		// When
		sut.reduce(.details(healthcareOrganization))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action(
			identifier: Coordination.Action.showHealthcareOrganization.identifier,
			params: ["healthcareOrganization": healthcareOrganization]
		)
	}
	
	func test_closeBanner_shouldRemoveBanner() {
		
		// Given
		sut.toast = Feedback(title: "test", subtitle: "test", type: .error)
		
		// When
		sut.reduce(.closeToast)
		
		// Then
		expect(self.sut.toast) == nil
	}
	
	func test_showToast() {
		
		// Given
		
		// When
		sut.reduce(.showToast(title: "title", subtitle: "subtitle"))
		
		// Then
		expect(self.sut.toast) != nil
	}
	
	func test_undo() {
		
		// Given
		let healthcareOrganization = Generator.healthcareOrganization("1")
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
		sut = OrganizationsViewModel(coordinator: coordinatorSpy)
		sut.reduce(.showToast(title: "title", subtitle: "subtitle"))
		
		// When
		sut.toast?.action?()
		
		// Then
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedSet) == true
		expect(self.sut.toast) == nil
	}
	
	func test_handleOrganizationChanges_added() {
		
		// Given
		
		// When
		sut.handleOrganizationChanges(.added)
		
		// Then
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedOrganizationsGetter) == true
		expect(self.sut.toast) == nil
	}
	
	func test_handleOrganizationChanges_removed() {
		
		// Given
		
		// When
		sut.handleOrganizationChanges(.removed)
		
		// Then
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedOrganizationsGetter) == true
		expect(self.sut.toast?.heading) == "Zorgaanbieder verwijderd"
		expect(self.sut.toast?.subheading) == "Herstel"
	}
	
	func test_handleOrganizationChanges_changed() {
		
		// Given
		
		// When
		sut.handleOrganizationChanges(.changed)
		
		// Then
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedOrganizationsGetter) == true
		expect(self.sut.toast?.heading) == "Zorgaanbieders aangepast"
		expect(self.sut.toast?.subheading) == "Herstel"
	}
}
