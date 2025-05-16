/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class HealthCategoryViewModelTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: HealthCategoryViewModel!
	private var healthcareOrganization: MgoOrganization!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1")
		setupSut(organization: healthcareOrganization)
	}
	
	func setupSut(organization: MgoOrganization?, category: HealthCategories.Category = HealthCategories.Category.medicalComplaints) {
		
		sut = HealthCategoryViewModel(
			coordinator: coordinatorSpy,
			category: category,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "hc_complaints.heading",
				search: "health_category.complaints.search",
				noSearchResults: "health_category.complaints.no_search_results",
				backButtonTitle: String.LocalizationValue(stringLiteral: "hc_complaints.heading")
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
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success([
			MgoResourceRecord(categoryId: "\(HealthCategories.Category.medication.rawValue)", organizationId: healthcareOrganization.identifier, resources: [], error: false)]
		)
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		if case let HealthCategoryViewState.list(items) = sut.state {
			expect(items).to(beEmpty())
		} else {
			fail("Invalid state")
		}
	}
	
	func test_loadResources_noResults_noOrganization() {

		// Given
		setupSut(organization: nil)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success([
			MgoResourceRecord(categoryId: "\(HealthCategories.Category.medication.rawValue)", organizationId: healthcareOrganization.identifier, resources: [], error: false)]
		)
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		if case let HealthCategoryViewState.list(items) = sut.state {
			expect(items).to(beEmpty())
		} else {
			fail("Invalid state")
		}
	}
	
	func test_loadResources_error() {

		// Given
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success([
			MgoResourceRecord(categoryId: "\(HealthCategories.Category.medication.rawValue)", organizationId: healthcareOrganization.identifier, resources: [], error: true)]
		)
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		if case let HealthCategoryViewState.partial(items) = sut.state {
			expect(items).to(beEmpty())
		} else {
			fail("Invalid state")
		}
	}
	
	func test_loadResources_withResults_noName() throws {
		
		// Given
		setupSut(organization: healthcareOrganization, category: HealthCategories.Category.medication)
		let resource = try getResource("zibMedicationUse")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success([
			MgoResourceRecord(categoryId: "\(HealthCategories.Category.medication.rawValue)", organizationId: healthcareOrganization.identifier, resources: [resource], error: false)]
		)
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		if case let HealthCategoryViewState.list(items) = sut.state {
			expect(items).toEventually(haveCount(1))
		} else {
			fail("Invalid state")
		}
	}
	
	func test_loadResources_withResults_withName() throws {

		// Given
		setupSut(organization: healthcareOrganization, category: HealthCategories.Category.medication)
		let resource = try getResource("zibMedicationUse")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success([
			MgoResourceRecord(categoryId: "\(HealthCategories.Category.medication.rawValue)", organizationId: healthcareOrganization.identifier, resources: [resource], error: false)]
		)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		if case let HealthCategoryViewState.list(items) = sut.state {
			expect(items).toEventually(haveCount(1))
		} else {
			fail("Invalid state")
		}
	}
	
	func test_loadResources_withResults_withName_action() throws {

		// Given
		setupSut(organization: healthcareOrganization, category: HealthCategories.Category.medication)
		let resource = try getResource("zibMedicationUse")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success([
			MgoResourceRecord(categoryId: "\(HealthCategories.Category.medication.rawValue)", organizationId: healthcareOrganization.identifier, resources: [resource], error: false)]
		)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
		sut.reduce(.onAppear)
		
		// When
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		if case let HealthCategoryViewState.list(items) = sut.state {
			items.first?.rows.first?.action?()
		} else {
			fail("Invalid state")
		}
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		let params = try XCTUnwrap(self.coordinatorSpy.invokedHandleParameters?.0)
		expect(params.identifier) == Coordination.Action.showHealthData.identifier
		expect(params.params["resource"] as? MgoResource) == resource
		expect(params.params["backButtonTitle"] as? String) == "Medische klachten"
		expect((params.params["uiSchema"] as? HealthUISchema)?.label) == "Zestril tablet 10mg"
	}
	
	func test_loadResources_withResults_withName_noOrganisation() throws {

		// Given
		setupSut(organization: nil, category: HealthCategories.Category.medication)
		let resource = try getResource("zibMedicationUse")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success([
			MgoResourceRecord(categoryId: "\(HealthCategories.Category.medication.rawValue)", organizationId: healthcareOrganization.identifier, resources: [resource], error: false)]
		)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		if case let HealthCategoryViewState.list(items) = sut.state {
			expect(items).toEventually(haveCount(1))
		} else {
			fail("Invalid state")
		}
	}
	
	func test_loadResources_noResults_cacheMiss() {
		
		// Given
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .failure(DataStoreError.noData)
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		if case let HealthCategoryViewState.list(items) = sut.state {
			expect(items).to(beEmpty())
		} else {
			fail("Invalid state")
		}
	}
	
	func test_retry() {
		
		// Given
		
		// When
		sut.reduce(.retry)
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedRemoveRecordsFor) == true
		expect(self.servicesSpies.resourceRepositorySpy.invokedLoadResourceCount).toEventually(equal(1), timeout: .seconds(5))
	}
	
	func test_retry_noOrganization() {
		
		// Given
		setupSut(organization: nil)
		
		// When
		sut.reduce(.retry)
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedRemoveRecordsFor) == true
		expect(self.servicesSpies.resourceRepositorySpy.invokedLoadForHealthCategoriesCategoryCount).toEventually(equal(1), timeout: .seconds(5))
	}
	
	func test_handleDataStoreChanges() {
		
		// Given
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success([
			MgoResourceRecord(categoryId: "\(HealthCategories.Category.medication.rawValue)", organizationId: healthcareOrganization.identifier, resources: [], error: false)]
		)
		
		// When
		sut.handleDataStoreChanges()
		
		// Then
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		if case let HealthCategoryViewState.list(items) = sut.state {
			expect(items).to(beEmpty())
		} else {
			fail("Invalid state")
		}
	}
	
	func test_handleDataStoreChanges_belowThreshold_shouldKeepLoading() {
		
		// Given
		setupSut(organization: healthcareOrganization, category: .medication)
		
		// one (empty) result, but medication does more than one call.
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success([
			MgoResourceRecord(categoryId: "\(HealthCategories.Category.medication.rawValue)", organizationId: healthcareOrganization.identifier, resources: [], error: false)]
		)
		
		// When
		sut.handleDataStoreChanges()
		
		// Then
		expect(self.sut.state) == .loading
	}
}
