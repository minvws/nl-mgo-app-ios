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
	}
	
	@MainActor func setupSut(
		organization: MgoOrganization?,
		categoryName: String = "problems"
	) throws {
		
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: categoryName))
		
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
	
	/// Create a resource record
	/// - Parameters:
	///   - resources: the resources for the record
	///   - error: boolean indicating fetch error
	/// - Returns: resource record
	private func resourceRecord(_ resources: [Data] = [], error: Bool = false) -> MgoResourceRecord {
		
		return MgoResourceRecord(
			categoryId: "medication",
			organizationId: healthcareOrganization.identifier,
			resources: resources,
			error: error
		)
	}
	
	@MainActor func test_initialState_shouldBeLoading() throws {
		
		// Given
		try setupSut(organization: healthcareOrganization)
		
		// When
		
		// Then
		expect(self.sut.state) == HealthCategoryViewState.loading
	}
	
	@MainActor func test_backButtonPressed_shouldCallCoordinator() throws {
		
		// Given
		try setupSut(organization: healthcareOrganization)
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
	
	@MainActor func test_loadResources_noResults() throws {
		
		// Given
		try setupSut(organization: healthcareOrganization)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[
				resourceRecord()
			]
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
	
	@MainActor func test_loadResources_noResults_noOrganization() throws {
		
		// Given
		try setupSut(organization: healthcareOrganization)
		try setupSut(organization: nil)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success(
			[
				resourceRecord()
			]
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
	
	@MainActor func test_loadResources_error() throws {
		
		// Given
		try setupSut(organization: healthcareOrganization)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[
				resourceRecord([], error: true)
			]
		)
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		if case let HealthCategoryViewState.partial(items) = sut.state {
			expect(items).toNot(beEmpty())
		} else {
			fail("Invalid state")
		}
	}
	
	@MainActor func test_loadResources_withResults_noName() throws {
		
		// Given
		try setupSut(organization: healthcareOrganization, categoryName: "medication")
		let resource = try getResource("zibMedicationUse")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[
				resourceRecord([resource])
			]
		)
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		if case let HealthCategoryViewState.list(items) = sut.state {
			expect(items).toEventually(haveCount(3))
			expect(items[0].rows).toNot(beEmpty())
			expect(items[1].rows).to(beEmpty())
			expect(items[2].rows).to(beEmpty())
		} else {
			fail("Invalid state")
		}
	}
	
	@MainActor func test_loadResources_withResults_withName() throws {
		
		// Given
		try setupSut(organization: healthcareOrganization, categoryName: "medication")
		let resource = try getResource("zibMedicationUse")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[
				resourceRecord([resource])
			]
		)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		if case let HealthCategoryViewState.list(items) = sut.state {
			expect(items).toEventually(haveCount(3))
			expect(items[0].rows).toNot(beEmpty())
			expect(items[1].rows).to(beEmpty())
			expect(items[2].rows).to(beEmpty())
		} else {
			fail("Invalid state")
		}
	}
	
	@MainActor func test_loadResources_withResults_withName_action() throws {
		
		// Given
		try setupSut(organization: healthcareOrganization, categoryName: "medication")
		let resource = try getResource("zibMedicationUse")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[
				resourceRecord([resource])
			]
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
	
	@MainActor func test_loadResources_withResults_withName_noOrganisation() throws {
		
		// Given
		try setupSut(organization: nil, categoryName: "medication")
		let resource = try getResource("zibMedicationUse")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success(
			[
				resourceRecord([resource])
			]
		)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		if case let HealthCategoryViewState.list(items) = sut.state {
			expect(items).toEventually(haveCount(3))
			expect(items[0].rows).toNot(beEmpty())
			expect(items[1].rows).to(beEmpty())
			expect(items[2].rows).to(beEmpty())
		} else {
			fail("Invalid state")
		}
	}
	
	@MainActor func test_loadResources_noResults_cacheMiss() throws {
		
		// Given
		try setupSut(organization: healthcareOrganization)
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
	
	@MainActor func test_retry() throws {
		
		// Given
		try setupSut(organization: healthcareOrganization)
		
		// When
		sut.reduce(.retry)
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedRemoveRecordsFor) == true
		expect(self.servicesSpies.resourceRepositorySpy.invokedLoadResourceCount).toEventually(equal(1), timeout: .seconds(5))
	}
	
	@MainActor func test_retry_noOrganization() throws {
		
		// Given
		try setupSut(organization: nil)
		
		// When
		sut.reduce(.retry)
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedRemoveRecordsFor) == true
		expect(self.servicesSpies.resourceRepositorySpy.invokedLoadForSharedHealthCategoriesCategoryCount).toEventually(equal(1), timeout: .seconds(5))
	}
	
	@MainActor func test_handleDataStoreChanges() throws {
		
		// Given
		try setupSut(organization: healthcareOrganization, categoryName: "medication")
		let resource = try getResource("zibMedicationUse")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[
				resourceRecord([resource]),
				resourceRecord([resource]),
				resourceRecord([resource])
			]
		)
		
		// When
		sut.handleDataStoreChanges()
		
		// Then
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		if case let HealthCategoryViewState.list(items) = sut.state {
			expect(items).toEventually(haveCount(3))
			expect(items[0].rows).toNot(beEmpty())
		} else {
			fail("Invalid state")
		}
	}
	
	@MainActor func test_handleDataStoreChanges_noMatchingProfiles() throws {
		
		// Given
		try setupSut(organization: healthcareOrganization)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[
				resourceRecord()
			]
		)
		
		// When
		sut.handleDataStoreChanges()
		
		// Then
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		if case let HealthCategoryViewState.list(items) = sut.state {
			expect(items).toEventually(beEmpty())
		} else {
			fail("Invalid state")
		}
	}
	
	@MainActor func test_handleDataStoreChanges_belowThreshold_shouldKeepLoading() throws {
		
		// Given
		try setupSut(organization: healthcareOrganization, categoryName: "medication")
		
		// one (empty) result, but medication does more than one call.
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[
				resourceRecord()
			]
		)
		
		// When
		sut.handleDataStoreChanges()
		
		// Then
		expect(self.sut.state) == .loading
	}
	
	@MainActor func test_showExportAlert() throws {
		
		// Given
		try setupSut(organization: healthcareOrganization)
		sut.showExportAlert = false
		
		// When
		sut.reduce(.showExportAlert)
		
		// Then
		expect(self.sut.showExportAlert) == true
	}
	
	@MainActor func test_cancelExportAlert() throws {
		
		// Given
		try setupSut(organization: healthcareOrganization)
		sut.showExportAlert = true
		
		// When
		sut.reduce(.cancelExportAlert)
		
		// Then
		expect(self.sut.showExportAlert) == false
	}
	
	@MainActor func test_exportHealthData_list_shouldCallCoordinator() throws {
		
		// Given
		try setupSut(organization: healthcareOrganization, categoryName: "medication")
		let resource = try getResource("zibMedicationUse")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[
				resourceRecord([resource])
			]
		)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
		sut.reduce(.onAppear)
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		
		// When
		sut.reduce(.exportHealthData)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0.identifier) == Coordination.Action.exportHealthData.identifier
		expect(self.coordinatorSpy.invokedHandleParameters?.0.params) != nil
	}
	
	@MainActor func test_exportHealthData_partialList_shouldCallCoordinator() throws {
		
		// Given
		try setupSut(organization: healthcareOrganization, categoryName: "medication")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[
				resourceRecord([], error: true)
			]
		)
		sut.reduce(.onAppear)
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		
		// When
		sut.reduce(.exportHealthData)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0.identifier) == Coordination.Action.exportHealthData.identifier
		expect(self.coordinatorSpy.invokedHandleParameters?.0.params) != nil
	}
	
	@MainActor func test_observe_dataStore() throws {
		
		// Given
		Container.shared.dataStore
			.register { InMemoryDataStore() }
		try setupSut(organization: healthcareOrganization)
		expect(self.sut.state) == .loading
		
		// When
		Container.shared.dataStore().observatory.notifyObservers(newValue: true)
		
		// Then
		expect(self.sut.state).toEventuallyNot(equal(.loading))
	}
}
