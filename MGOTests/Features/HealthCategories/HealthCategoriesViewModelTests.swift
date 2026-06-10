/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
import MGOFoundation
import MGOUI
@testable import MGO

@MainActor
@Suite(.serialized)
struct HealthCategoriesViewModelTests {
	
	private let coordinatorSpy: DashboardCoordinatorSpy
	private let servicesSpies: ServicesSpies
	private let healthcareOrganization: OrganizationSearch.Organization
	
	init() {
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1")
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
	}
	
	private func makeSut() -> HealthCategoriesViewModel {
		HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .single(healthcareOrganization))
	}
	
	@Test("Back button press routes to coordinator")
	func backButtonPressed_shouldCallCoordinator() {
		
		// Given
		let sut = makeSut()
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		#expect(coordinatorSpy.invokedHandle == true)
		#expect(coordinatorSpy.invokedHandleParameters?.0 == Coordination.Action.backButtonPressed)
	}
	
	@Test("Selecting a category routes with category and organization params")
	func categorySelected_shouldCallCoordinator() throws {
		
		// Given
		let sut = makeSut()
		let sharedCategories = try SharedHealthCategories()
		let category = try #require(sharedCategories.findCategory(id: "measurements"))
		
		// When
		sut.reduce(.categorySelected(category))
		
		// Then
		#expect(coordinatorSpy.invokedHandle == true)
		let params = try #require(coordinatorSpy.invokedHandleParameters?.0)
		#expect(params.identifier == Coordination.Action.showHealthCategory.identifier)
		#expect(params.params["category"] as? SharedHealthCategories.Category == category)
		#expect(params.params["healthcareOrganization"] != nil)
	}
	
	@Test("showRemovalDialog flips the confirmation flag in single mode")
	func showRemovalDialog_shouldPresentConfirmation() async throws {

		// Given
		let sut = makeSut()
		#expect(sut.state.showRemoveHealthcareProviderDialog == false)

		// When
		sut.reduce(.showRemovalDialog)
		// The reducer defers the state flip to the next runloop tick so the
		// menu's dismissal animation transaction is no longer active.
		await Task.yield()
		await Task.yield()

		// Then
		#expect(sut.state.showRemoveHealthcareProviderDialog == true)
	}

	@Test("Removing the organization clears data and notifies the coordinator")
	func removeHealthcareOrganization_shouldCallCoordinator() throws {
		
		// Given
		let sut = makeSut()
		
		// When
		sut.reduce(.removeHealthcareOrganization)
		
		// Then
		#expect(coordinatorSpy.invokedHandle == true)
		#expect(servicesSpies.dataStoreSpy.invokedRemoveRecords == true)
		#expect(servicesSpies.healthcareOrganizationStoreSpy.invokedRemove == true)
		let params = try #require(coordinatorSpy.invokedHandleParameters?.0)
		#expect(params.identifier == Coordination.Action.removedHealthcareOrganization.identifier)
	}
	
	@Test("onAppear with full medication data sets state to .loaded")
	func loadMedication_withData() async throws {
		
		// Given
		let sut = makeSut()
		let resource = try getResource("zibMedicationUse")
		let mgoResource = MgoResourceRecord(
			categoryId: "medication",
			organizationId: healthcareOrganization.identifier,
			resources: [resource],
			error: false
		)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[mgoResource, mgoResource, mgoResource, mgoResource]
		)
		#expect(sut.state.buttonState["medication"] == .loading)
		
		// When
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()
		
		// Then
		#expect(sut.state.buttonState["medication"] == .loaded)
	}
	
	@Test("onAppear with server-error records sets state to .serverError")
	func loadMedication_withServerErrorData() async throws {
		
		// Given
		let sut = makeSut()
		let mgoResource = MgoResourceRecord(
			categoryId: "medication",
			organizationId: healthcareOrganization.identifier,
			resources: [],
			error: ResourceRepositoryError.server.rawValue
		)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[mgoResource, mgoResource, mgoResource, mgoResource]
		)
		#expect(sut.state.buttonState["medication"] == .loading)
		
		// When
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()
		
		// Then
		#expect(sut.state.buttonState["medication"] == .serverError)
	}
	
	@Test("onAppear with client-error records sets state to .clientError")
	func loadMedication_withClientErrorData() async throws {
		
		// Given
		let sut = makeSut()
		let mgoResource = MgoResourceRecord(
			categoryId: "medication",
			organizationId: healthcareOrganization.identifier,
			resources: [],
			error: ResourceRepositoryError.client.rawValue
		)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[mgoResource, mgoResource, mgoResource, mgoResource]
		)
		#expect(sut.state.buttonState["medication"] == .loading)
		
		// When
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()
		
		// Then
		#expect(sut.state.buttonState["medication"] == .clientError)
	}
	
	@Test("onAppear with empty resource records sets state to .empty")
	func loadMedication_emptyData_stateShouldBeEmpty() async throws {
		
		// Given
		let sut = makeSut()
		let mgoResource = MgoResourceRecord(
			categoryId: "medication",
			organizationId: healthcareOrganization.identifier,
			resources: [],
			error: false
		)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[mgoResource, mgoResource, mgoResource, mgoResource]
		)
		#expect(sut.state.buttonState["medication"] == .loading)
		
		// When
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()
		
		// Then
		#expect(sut.state.buttonState["medication"] == .empty)
	}
	
	@Test("onAppear with .noData failure keeps state as .loading")
	func loadMedication_noData_stateShouldBeLoading() async throws {
		
		// Given
		let sut = makeSut()
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .failure(DataStoreError.noData)
		#expect(sut.state.buttonState["medication"] == .loading)
		
		// When
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()
		
		// Then
		#expect(sut.state.buttonState["medication"] == .loading)
	}
	
	@Test("onAppear with arbitrary data-store error sets state to .serverError")
	func loadMedication_dataError_stateShouldBeError() async throws {
		
		// Given
		let sut = makeSut()
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .failure(NSError(domain: "test_loadMedication_dataError_stateShouldBeEmpty", code: 404))
		#expect(sut.state.buttonState["medication"] == .loading)
		
		// When
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()
		
		// Then
		#expect(sut.state.buttonState["medication"] == .serverError)
	}
	
	@Test("Refresh in single mode targets the organization, not all records")
	func refresh() {
		
		// Given
		let sut = makeSut()
		#expect(sut.state.buttonState["medication"] == .loading)
		
		// When
		sut.reduce(.refresh)
		
		// Then
		#expect(servicesSpies.dataStoreSpy.invokedRemoveRecords == true)
		#expect(servicesSpies.dataStoreSpy.invokedRemoveAllRecords == false)
		#expect(servicesSpies.resourceRepositorySpy.invokedLoadCount == 0)
		#expect(servicesSpies.resourceRepositorySpy.invokedLoadForOrganizationCount == 1)
	}
	
	@Test("Retry reloads only the faulty categories for the current organization")
	func retry() {
		
		// Given
		let sut = makeSut()
		sut.state.buttonState["medication"] = .clientError
		
		// When
		sut.reduce(.retry)
		
		// Then
		#expect(servicesSpies.dataStoreSpy.invokedRemoveRecords == false)
		#expect(servicesSpies.dataStoreSpy.invokedRemoveAllRecords == false)
		#expect(servicesSpies.dataStoreSpy.invokedRemoveRecordsFor == true)
		#expect(servicesSpies.resourceRepositorySpy.invokedLoadCount == 0)
		#expect(servicesSpies.resourceRepositorySpy.invokedLoadForOrganizationCount == 0)
		#expect(servicesSpies.resourceRepositorySpy.invokedLoadForSharedHealthCategoriesCategoriesCount == 0)
		#expect(servicesSpies.resourceRepositorySpy.invokedLoadResourceCount == 1)
	}
	
	@Test("showFavorites in .all mode routes to coordinator")
	func showFavorites_modeAll_shouldCallCoordinator() {
		
		// Given
		let sut = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
		
		// When
		sut.reduce(.showFavorites)
		
		// Then
		#expect(coordinatorSpy.invokedHandle == true)
		#expect(coordinatorSpy.invokedHandleParameters?.0 == Coordination.Action.showFavorites)
	}
	
	@Test("showFavorites in .single mode does not route")
	func showFavorites_modeSingle_shouldNotCallCoordinator() {
		
		// Given
		let sut = makeSut()
		
		// When
		sut.reduce(.showFavorites)
		
		// Then
		#expect(coordinatorSpy.invokedHandle == false)
	}
}
