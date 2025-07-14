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
	}
	
	@MainActor func createSut() {
		
		sut = OrganizationsViewModel(coordinator: coordinatorSpy)
	}
	
	@MainActor func test_onAppear_shouldCallStore_noOrganzations_stateShouldBeEmtpy() {
		
		// Given
		createSut()
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = []
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedOrganizationsGetter) == true
		expect(self.sut.state) == .empty
	}
	
	@MainActor func test_onAppear_shouldCallStore_withOrganizations_stateShouldBeList() {
		
		// Given
		createSut()
		let healthcareOrganization = Generator.healthcareOrganization("1")
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedOrganizationsGetter) == true
		expect(self.sut.state) == .list([healthcareOrganization])
	}
	
	@MainActor func test_searchButtonPressed_shouldCallCoordinator() {
		
		// Given
		createSut()
		
		// When
		sut.reduce(.search)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.addHealthcareOrganization
	}
	
	@MainActor func test_detailsButtonPressed_shouldCallCoordinator() {
		
		// Given
		createSut()
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
	
	@MainActor func test_closeBanner_shouldRemoveBanner() {
		
		// Given
		createSut()
		sut.toast = Feedback(title: "test", subtitle: "test", type: .error)
		
		// When
		sut.reduce(.closeToast)
		
		// Then
		expect(self.sut.toast) == nil
	}
	
	@MainActor func test_showToast() {
		
		// Given
		createSut()
		
		// When
		sut.reduce(.showToast(title: "title", subtitle: "subtitle"))
		
		// Then
		expect(self.sut.toast) != nil
	}
	
	@MainActor func test_undo() {
		
		// Given
		createSut()
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
	
	@MainActor func test_handleOrganizationChanges_added() {
		
		// Given
		createSut()
		
		// When
		sut.handleOrganizationChanges(.added)
		
		// Then
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedOrganizationsGetter) == true
		expect(self.sut.toast) == nil
	}
	
	@MainActor func test_handleOrganizationChanges_removed() {
		
		// Given
		createSut()
		
		// When
		sut.handleOrganizationChanges(.removed)
		
		// Then
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedOrganizationsGetter) == true
		expect(self.sut.toast?.heading) == "Zorgaanbieder verwijderd"
		expect(self.sut.toast?.subheading) == "Herstel"
	}
	
	@MainActor func test_handleOrganizationChanges_changed() {
		
		// Given
		createSut()
		
		// When
		sut.handleOrganizationChanges(.changed)
		
		// Then
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedOrganizationsGetter) == true
		expect(self.sut.toast?.heading) == "Zorgaanbieders aangepast"
		expect(self.sut.toast?.subheading) == "Herstel"
	}
}
