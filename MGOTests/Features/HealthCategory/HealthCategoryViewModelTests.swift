/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
import MGOFoundation
import MGOUI
@testable import MGO

// swiftlint:disable type_body_length
@MainActor
@Suite(.serialized)
struct HealthCategoryViewModelTests {

	private let coordinatorSpy: DashboardCoordinatorSpy
	private let servicesSpies: ServicesSpies
	private let healthcareOrganization: OrganizationSearch.Organization
	private let fileStorageSpy: FileStorageSpy

	init() {
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1")
		fileStorageSpy = FileStorageSpy()
	}

	private func makeSut(
		organization: OrganizationSearch.Organization?,
		categoryName: String = "problems"
	) throws -> HealthCategoryViewModel {

		let sharedCategories = try SharedHealthCategories()
		let category = try #require(sharedCategories.findCategory(id: categoryName))

		return HealthCategoryViewModel(
			coordinator: coordinatorSpy,
			category: category,
			organization: organization,
			fileStorage: fileStorageSpy
		)
	}

	private func resourceRecord(_ resources: [Data] = [], error: Int? = nil) -> MgoResourceRecord {

		return MgoResourceRecord(
			categoryId: "medication",
			organizationId: healthcareOrganization.identifier,
			resources: resources,
			error: error
		)
	}

	// MARK: - Initial state

	@Test("Initial state is loading")
	func initialState_shouldBeLoading() throws {

		// Given
		let sut = try makeSut(organization: healthcareOrganization)

		// Then
		#expect(sut.state == HealthCategoryViewState.loading)
	}

	// MARK: - Basic interaction

	@Test("Tapping back calls coordinator with backButtonPressed")
	func backButtonPressed_shouldCallCoordinator() throws {

		// Given
		let sut = try makeSut(organization: healthcareOrganization)

		// When
		sut.reduce(.backButtonPressed)

		// Then
		#expect(coordinatorSpy.invokedHandle == true)
		#expect(coordinatorSpy.invokedHandleParameters?.0 == Coordination.Action.backButtonPressed)
	}

	// MARK: - Load resources

	@Test("onAppear with empty record transitions to an empty list and no error")
	func loadResources_noResults() async throws {

		// Given
		let sut = try makeSut(organization: healthcareOrganization)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[resourceRecord()]
		)

		// When
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()

		// Then
		guard case let .list(items, errorState) = sut.state else {
			Issue.record("Expected .list state, got \(sut.state)")
			return
		}
		#expect(items.isEmpty)
		#expect(errorState == HealthCategoriesErrorState.none)
	}

	@Test("onAppear with no organization uses all-organization data store query")
	func loadResources_noResults_noOrganization() async throws {

		// Given
		let sut = try makeSut(organization: nil)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success(
			[resourceRecord()]
		)

		// When
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()

		// Then
		guard case let .list(items, errorState) = sut.state else {
			Issue.record("Expected .list state, got \(sut.state)")
			return
		}
		#expect(items.isEmpty)
		#expect(errorState == HealthCategoriesErrorState.none)
	}

	@Test("onAppear with server error shows error state")
	func loadResources_serverError() async throws {

		// Given
		let sut = try makeSut(organization: healthcareOrganization)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[resourceRecord([], error: 1)]
		)

		// When
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()

		// Then
		guard case let .list(items, errorState) = sut.state else {
			Issue.record("Expected .list state, got \(sut.state)")
			return
		}
		#expect(items.isEmpty)
		#expect(errorState == HealthCategoriesErrorState.error(
			heading: "Gegevens niet opgehaald",
			subHeading: "Helaas konden we door een probleem aan onze kant uw gegevens niet ophalen."
		))
	}

	@Test("onAppear with client error shows error state")
	func loadResources_clientError() async throws {

		// Given
		let sut = try makeSut(organization: healthcareOrganization)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[resourceRecord([], error: -1)]
		)

		// When
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()

		// Then
		guard case let .list(items, errorState) = sut.state else {
			Issue.record("Expected .list state, got \(sut.state)")
			return
		}
		#expect(items.isEmpty)
		#expect(errorState == HealthCategoriesErrorState.error(
			heading: "Gegevens niet opgehaald",
			subHeading: "Er ging iets mis bij het ophalen. Controleer uw verbinding en probeer het opnieuw."
		))
	}

	@Test("onAppear with medication resource populates rows in first subcategory")
	func loadResources_withResults_noName() async throws {

		// Given
		let sut = try makeSut(organization: healthcareOrganization, categoryName: "medication")
		let resource = try getResource("zibMedicationUse")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[resourceRecord([resource])]
		)

		// When
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()

		// Then
		guard case let .list(items, errorState) = sut.state else {
			Issue.record("Expected .list state, got \(sut.state)")
			return
		}
		#expect(items.count == 1)
		#expect(items[0].rows.isEmpty == false)
		#expect(errorState == HealthCategoriesErrorState.none)
	}

	@Test("onAppear with known organization name populates rows")
	func loadResources_withResults_withName() async throws {

		// Given
		let sut = try makeSut(organization: healthcareOrganization, categoryName: "medication")
		let resource = try getResource("zibMedicationUse")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[resourceRecord([resource])]
		)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]

		// When
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()

		// Then
		guard case let .list(items, errorState) = sut.state else {
			Issue.record("Expected .list state, got \(sut.state)")
			return
		}
		#expect(items.count == 1)
		#expect(items[0].rows.isEmpty == false)
		#expect(errorState == HealthCategoriesErrorState.none)
	}

	@Test("Tapping a row navigates to showHealthData")
	func loadResources_withResults_withName_action() async throws {

		// Given
		let sut = try makeSut(organization: healthcareOrganization, categoryName: "medication")
		let resource = try getResource("zibMedicationUse")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[resourceRecord([resource])]
		)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()

		// When
		guard case let .list(items, _) = sut.state else {
			Issue.record("Expected .list state, got \(sut.state)")
			return
		}
		items.first?.rows.first?.action?()

		// Then
		#expect(coordinatorSpy.invokedHandle == true)
		let params = try #require(coordinatorSpy.invokedHandleParameters?.0)
		#expect(params.identifier == Coordination.Action.showHealthData.identifier)
		#expect(params.params["resource"] as? MgoResource == resource)
		#expect(params.params["backButtonTitle"] as? String == "common.previous")
		#expect((params.params["uiSchema"] as? HealthUISchema)?.label == "Zestril tablet 10mg")
	}

	@Test("onAppear with no organisation uses all-org query and populates rows")
	func loadResources_withResults_withName_noOrganisation() async throws {

		// Given
		let sut = try makeSut(organization: nil, categoryName: "medication")
		let resource = try getResource("zibMedicationUse")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success(
			[resourceRecord([resource])]
		)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]

		// When
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()

		// Then
		guard case let .list(items, _) = sut.state else {
			Issue.record("Expected .list state, got \(sut.state)")
			return
		}
		#expect(items.count == 1)
		#expect(items[0].rows.isEmpty == false)
	}

	@Test("onAppear with cache miss keeps loading state")
	func loadResources_noResults_cacheMiss() throws {

		// Given
		let sut = try makeSut(organization: healthcareOrganization)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .failure(DataStoreError.noData)

		// When
		sut.reduce(.onAppear)

		// Then — cache miss on first load (threshold == 0) keeps loading state
		// until the data store observer delivers real data.
		#expect(sut.state == .loading)
	}

	@Test("Second onAppear is a no-op when already in list state")
	func onAppear_idempotent_whenAlreadyLoaded() async throws {

		// Given — bring the view model into .list state via first onAppear
		let sut = try makeSut(organization: healthcareOrganization)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[resourceRecord()]
		)
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()
		#expect(sut.state != .loading)

		// Reset spies — first onAppear made 2 remove() calls (binary + export)
		servicesSpies.dataStoreSpy.invokedGetCategoryIdOrganizationId = false
		fileStorageSpy.invokedRemoveCount = 0

		// When — second onAppear (simulates navigating away and back)
		sut.reduce(.onAppear)
		await Task.yield()

		// Then — no data store access and no file wipe triggered by the second call
		#expect(servicesSpies.dataStoreSpy.invokedGetCategoryIdOrganizationId == false)
		#expect(fileStorageSpy.invokedRemoveCount == 0)
	}

	// MARK: - Retry

	@Test("retry removes faulty records and triggers a reload")
	func retry() throws {

		// Given
		let sut = try makeSut(organization: healthcareOrganization)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[resourceRecord([], error: 1)]
		)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]

		// When
		sut.reduce(.retry)

		// Then
		#expect(servicesSpies.dataStoreSpy.invokedRemoveRecordsFor == true)
		#expect(servicesSpies.resourceRepositorySpy.invokedLoadResourceCount == 1)
	}

	@Test("retry with no organization performs no data store or repository calls")
	func retry_noOrganization() throws {

		// Given
		let sut = try makeSut(organization: healthcareOrganization)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[resourceRecord([], error: 1)]
		)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = []

		// When
		sut.reduce(.retry)

		// Then
		#expect(servicesSpies.dataStoreSpy.invokedRemoveRecordsFor == false)
		#expect(servicesSpies.resourceRepositorySpy.invokedLoadResourceCount == 0)
	}

	// MARK: - Data store changes

	@Test("handleDataStoreChanges with multiple records populates all rows")
	func handleDataStoreChanges() async throws {

		// Given
		let sut = try makeSut(organization: healthcareOrganization, categoryName: "medication")
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
		await Task.yield()
		await Task.yield()

		// Then
		guard case let .list(items, errorState) = sut.state else {
			Issue.record("Expected .list state, got \(sut.state)")
			return
		}
		#expect(items.count == 1)
		#expect(items[0].rows.count == 3)
		#expect(errorState == HealthCategoriesErrorState.none)
	}

	@Test("handleDataStoreChanges with no matching profiles produces empty rows")
	func handleDataStoreChanges_noMatchingProfiles() async throws {

		// Given
		let sut = try makeSut(organization: healthcareOrganization)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[resourceRecord()]
		)

		// When
		sut.handleDataStoreChanges()
		await Task.yield()
		await Task.yield()

		// Then
		guard case let .list(items, errorState) = sut.state else {
			Issue.record("Expected .list state, got \(sut.state)")
			return
		}
		#expect(items.isEmpty)
		#expect(errorState == HealthCategoriesErrorState.none)
	}

	@Test("handleDataStoreChanges below result threshold keeps loading state")
	func handleDataStoreChanges_belowThreshold_shouldKeepLoading() throws {

		// Given
		let sut = try makeSut(organization: healthcareOrganization, categoryName: "medication")
		// one (empty) result, but medication expects more than one call
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[resourceRecord()]
		)

		// When
		sut.handleDataStoreChanges()

		// Then
		#expect(sut.state == .loading)
	}

	// MARK: - Export alert

	@Test("showExportAlert sets showExportAlert to true")
	func showExportAlert() throws {

		// Given
		let sut = try makeSut(organization: healthcareOrganization)
		sut.showExportAlert = false

		// When
		sut.reduce(.showExportAlert)

		// Then
		#expect(sut.showExportAlert == true)
	}

	// MARK: - Export health data

	@Test("exportHealthData with list state calls coordinator with exportHealthData")
	func exportHealthData_list_shouldCallCoordinator() async throws {

		// Given
		let sut = try makeSut(organization: healthcareOrganization, categoryName: "medication")
		let resource = try getResource("zibMedicationUse")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[resourceRecord([resource])]
		)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()
		#expect(sut.state != .loading)

		// When
		sut.reduce(.exportHealthData)

		// Then
		#expect(coordinatorSpy.invokedHandle == true)
		#expect(coordinatorSpy.invokedHandleParameters?.0.identifier == Coordination.Action.exportHealthData.identifier)
		#expect(coordinatorSpy.invokedHandleParameters?.0.params != nil)
	}

	@Test("exportHealthData with partial list (error record) calls coordinator with exportHealthData")
	func exportHealthData_partialList_shouldCallCoordinator() async throws {

		// Given
		let sut = try makeSut(organization: healthcareOrganization, categoryName: "medication")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[resourceRecord([], error: 404)]
		)
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()
		#expect(sut.state != .loading)

		// When
		sut.reduce(.exportHealthData)

		// Then
		#expect(coordinatorSpy.invokedHandle == true)
		#expect(coordinatorSpy.invokedHandleParameters?.0.identifier == Coordination.Action.exportHealthData.identifier)
		#expect(coordinatorSpy.invokedHandleParameters?.0.params != nil)
	}

	// MARK: - Observer

	@Test("Data store notification triggers state update via debounced observer")
	func observe_dataStore() async throws {

		// Given
		Container.shared.dataStore
			.register { InMemoryDataStore() }
		let sut = try makeSut(organization: healthcareOrganization)
		#expect(sut.state == .loading)

		// When
		Container.shared.dataStore().observatory.notifyObservers(newValue: true)

		// Then — wait for 150ms debounce + scheduling buffer
		try await Task.sleep(nanoseconds: 300_000_000)
		await Task.yield()
		#expect(sut.state != .loading)
	}
}
// swiftlint:enable type_body_length
