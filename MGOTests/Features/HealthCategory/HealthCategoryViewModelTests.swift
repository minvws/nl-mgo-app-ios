/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO
import Zibs

final class HealthCategoryViewModelTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: HealthCategoryViewModel!
	private var healthcareOrganization: MgoOrganization!
	
	override func setUp() {
		
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1")
		setupSut(organizationId: healthcareOrganization.identifier)
	}
	
	func setupSut(organizationId: String?) {
		
		sut = HealthCategoryViewModel(
			coordinator: coordinatorSpy,
			categoryId: "\(HealthCategories.Category.complaints.rawValue)",
			organizationId: organizationId,
			translations: HealthCategoryViewTranslations(
				heading: "health_category.complaints",
				search: "health_category.complaints.search",
				noSearchResults: "health_category.complaints.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "health_category.complaints.details_heading")
			)
		)
	}
	
	func test_initialState_shouldBeLoading() {
		
		// Given
		
		// When
		
		// Then
		expect(self.sut.state) == HealthCategoryViewState.loading
	}
	
	func test_backButtonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
	
	func test_loadResources_noResults() {
		
		// Given
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success([
			MgoResourceRecord(categoryId: "\(HealthCategories.Category.medication.rawValue)", organizationId: healthcareOrganization.identifier, resources: [], error: false)]
		)
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(HealthCategoryViewState.empty))
	}
	
	func test_loadResources_noResults_noOrganizationId() {

		// Given
		setupSut(organizationId: nil)
		servicesSpies.dataStoreSpy.stubbedGetResult = .success([
			MgoResourceRecord(categoryId: "\(HealthCategories.Category.medication.rawValue)", organizationId: healthcareOrganization.identifier, resources: [], error: false)]
		)
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(HealthCategoryViewState.empty))
	}
	
	func test_loadResources_withResults_noName() throws {
		
		// Given
		let resource = try getResource("zibMedicationUse")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success([
			MgoResourceRecord(categoryId: "\(HealthCategories.Category.medication.rawValue)", organizationId: healthcareOrganization.identifier, resources: [resource], error: false)]
		)
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		if case let HealthCategoryViewState.success(items) = sut.state {
			expect(items).toEventually(haveCount(1))
		} else {
			fail("Invalid state")
		}
	}
	
	func test_loadResources_withResults_withName() throws {

		// Given
		let resource = try getResource("zibMedicationUse")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success([
			MgoResourceRecord(categoryId: "\(HealthCategories.Category.medication.rawValue)", organizationId: healthcareOrganization.identifier, resources: [resource], error: false)]
		)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		if case let HealthCategoryViewState.success(items) = sut.state {
			expect(items).toEventually(haveCount(1))
		} else {
			fail("Invalid state")
		}
	}
	
	func test_loadResources_withResults_withName_action() throws {

		// Given
		let resource = try getResource("zibMedicationUse")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success([
			MgoResourceRecord(categoryId: "\(HealthCategories.Category.medication.rawValue)", organizationId: healthcareOrganization.identifier, resources: [resource], error: false)]
		)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
		sut.reduce(.onAppear)
		
		// When
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		if case let HealthCategoryViewState.success(items) = sut.state {
			items.first?.action?()
		} else {
			fail("Invalid state")
		}
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		let params = try XCTUnwrap(self.coordinatorSpy.invokedHandleParameters?.0)
		expect(params.identifier) == Coordination.Action.showZibDetails.identifier
		expect(params.params["resource"] as? MgoResource) == resource
		expect(params.params["heading"] as? String) == "Alle klachtgegevens"
		expect((params.params["uiSchema"] as? UISchema)?.label) == "Zestril tablet 10mg"
		
	}
	
	func test_loadResources_withResults_withName_noOrganisationId() throws {

		// Given
		setupSut(organizationId: nil)
		let resource = try getResource("zibMedicationUse")
		servicesSpies.dataStoreSpy.stubbedGetResult = .success([
			MgoResourceRecord(categoryId: "\(HealthCategories.Category.medication.rawValue)", organizationId: healthcareOrganization.identifier, resources: [resource], error: false)]
		)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		if case let HealthCategoryViewState.success(items) = sut.state {
			expect(items).toEventually(haveCount(1))
		} else {
			fail("Invalid state")
		}
	}
	
	func test_loadResources_noResults_cacheMiss() {
		
		// Given
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .failure(DataStoreError.noData)
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(.failure))
	}
}
