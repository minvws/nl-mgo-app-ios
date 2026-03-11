/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGO
import Testing
import OrganizationSearch
import MGOFoundation
import MGOUI

@MainActor
final class SearchOrganizationViewModelTests {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	private var sut: SearchOrganizationViewModel!
	private var servicesSpies: ServicesSpies!
	
	init() async throws {
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		sut = SearchOrganizationViewModel(
			coordinator: coordinatorSpy,
			firstVisitor: false
		)
	}
	
	// MARK: - closeSheet Action Tests
	
	@Test("Reduce closeSheet should call coordinator to close sheet")
	func reduce_closeSheet_shouldCallCoordinator() {
		
		// Given
		// Initial state setup in init
		
		// When
		sut.reduce(.closeSheet)
		
		// Then
		#expect(coordinatorSpy.invokedHandle == true)
		#expect(coordinatorSpy.invokedHandleParameters?.0 == Coordination.Action.closeSheet)
	}
	
	// MARK: - endEditing Action Tests
	
	@Test("Reduce endEditing should end editing")
	func reduce_endEditing_shouldEndEditing() {
		
		// Given
		// Initial state setup in init
		
		// When
		sut.reduce(.endEditing)
		
		// Then
		// Note: This test verifies the action is handled
		// UIApplication.shared.endEditing() is called internally
		// We can't easily verify this without mocking UIApplication
		#expect(coordinatorSpy.invokedHandle == false)
	}
	
	// MARK: - search Action Tests
	
	@Test("Reduce search with nil search term should clear results")
	func reduce_search_withNilSearchTerm_shouldClearResults() {
		
		// Given
		sut.state.results = [Generator.searchOrganization()]
		sut.state.totalResults = 1
		sut.state.isSearching = true
		
		// When
		sut.reduce(.search(nil))
		
		// Then
		#expect(sut.state.results.isEmpty)
		#expect(sut.state.totalResults == 0)
		#expect(sut.state.isSearching == false)
	}
	
	@Test("Reduce search with empty search term should clear results")
	func reduce_search_withEmptySearchTerm_shouldClearResults() {
		
		// Given
		sut.state.results = [Generator.searchOrganization()]
		sut.state.totalResults = 1
		sut.state.isSearching = true
		
		// When
		sut.reduce(.search(""))
		
		// Then
		#expect(sut.state.results.isEmpty)
		#expect(sut.state.totalResults == 0)
		#expect(sut.state.isSearching == false)
	}
	
	@Test("Reduce search with short search term should clear results")
	func reduce_search_withShortSearchTerm_shouldClearResults() {
		
		// Given
		sut.state.results = [Generator.searchOrganization()]
		sut.state.totalResults = 1
		sut.state.isSearching = true
		
		// When
		sut.reduce(.search("AB"))
		
		// Then
		#expect(sut.state.results.isEmpty)
		#expect(sut.state.totalResults == 0)
		#expect(sut.state.isSearching == false)
	}
	
	@Test("Reduce search with valid search term should set isSearching to true")
	func reduce_search_withValidSearchTerm_shouldSetIsSearchingToTrue() async {

		// Given
		sut.state.isSearching = false
		servicesSpies.searchOrganizationClientSpy.stubbedSearchHealthcareOrganizationsSearchResults = SearchResults(count: 0, hits: [])

		// When
		sut.reduce(.search("Test"))

		// Then - isSearching is set synchronously before the debounced Task fires
		#expect(sut.state.isSearching == true)

		// Wait past the 100 ms debounce delay so the search task reaches the client call
		try? await Task.sleep(nanoseconds: 200 * 1_000_000)

		#expect(servicesSpies.searchOrganizationClientSpy.invokedSearchHealthcareOrganizations == true)
		#expect(servicesSpies.searchOrganizationClientSpy.invokedSearchHealthcareOrganizationsParameters?.searchTerm == "Test")
	}

	@Test("Reduce search with HTML tags around a valid term should sanitize and search")
	func reduce_search_withHTMLWrappedTerm_shouldSanitizeAndSearch() async {

		// Given
		sut.state.isSearching = false
		servicesSpies.searchOrganizationClientSpy.stubbedSearchHealthcareOrganizationsSearchResults = SearchResults(count: 0, hits: [])

		// When - <b>Test</b> strips to "Test" (> 2 chars), so a search should start
		sut.reduce(.search("<b>Test</b>"))

		// Wait past the 100 ms debounce delay so the search task reaches the client call
		try? await Task.sleep(nanoseconds: 200 * 1_000_000)

		// Then
		#expect(sut.state.isSearching == false)
		#expect(servicesSpies.searchOrganizationClientSpy.invokedSearchHealthcareOrganizations == true)
		#expect(servicesSpies.searchOrganizationClientSpy.invokedSearchHealthcareOrganizationsParameters?.searchTerm == "Test")
	}

	@Test("Reduce search with HTML-only input should clear results")
	func reduce_search_withHTMLOnlyInput_shouldClearResults() {

		// Given
		sut.state.results = [Generator.searchOrganization()]
		sut.state.totalResults = 1
		sut.state.isSearching = true

		// When - <b></b> strips to an empty string, so results should be cleared
		sut.reduce(.search("<b></b>"))

		// Then
		#expect(sut.state.results.isEmpty)
		#expect(sut.state.totalResults == 0)
		#expect(sut.state.isSearching == false)
	}

	// MARK: - store Action Tests
	
	@Test("Reduce store should call coordinator to finish searching")
	func reduce_store_shouldCallCoordinatorToFinishSearching() {
		
		// Given
		let organization = Generator.searchOrganization(
			dataServices: [
				"50": OrganizationSearch.DataService(
					authEndpoint: "test",
					resourceEndpoint: "test",
					tokenEndpoint: "test"
				)
			]
		)
		
		// When
		sut.reduce(.store(organization))
		
		// Then
		#expect(
			servicesSpies.healthcareOrganizationStoreSpy.invokedStore == true
		)
		#expect(coordinatorSpy.invokedHandle == true)
		#expect(coordinatorSpy.invokedHandleParameters?.0 == Coordination.Action.closeSheet)
	}
	
	// MARK: - loadMore Action Tests

	@Test("Reduce loadMore should increase visibleCount by pageSize")
	func reduce_loadMore_shouldIncreaseVisibleCount() {

		// Given
		let organizations = (0..<50).map { _ in Generator.searchOrganization() }
		sut.state.results = organizations
		sut.state.visibleCount = SearchOrganizationViewModel.pageSize

		// When
		sut.reduce(.loadMore)

		// Then
		#expect(sut.state.visibleCount == SearchOrganizationViewModel.pageSize * 2)
	}

	@Test("Reduce loadMore should not exceed total results count")
	func reduce_loadMore_shouldNotExceedResultsCount() {

		// Given
		let organizations = (0..<25).map { _ in Generator.searchOrganization() }
		sut.state.results = organizations
		sut.state.visibleCount = SearchOrganizationViewModel.pageSize

		// When
		sut.reduce(.loadMore)

		// Then
		#expect(sut.state.visibleCount == organizations.count)
	}

	// MARK: - State Tests
	
	@Test("Initial state should be configured correctly for first visitor")
	func initialState_firstVisitor_shouldBeConfiguredCorrectly() async throws {
		
		// Given
		let firstVisitorSut = SearchOrganizationViewModel(
			coordinator: coordinatorSpy,
			firstVisitor: true
		)
		
		// When
		// Initial state
		
		// Then
		#expect(firstVisitorSut.state.isOnboarding == true)
		#expect(firstVisitorSut.state.isSearching == false)
		#expect(firstVisitorSut.state.results.isEmpty)
		#expect(firstVisitorSut.state.totalResults == 0)
	}
	
	@Test("Initial state should be configured correctly for returning visitor")
	func initialState_returningVisitor_shouldBeConfiguredCorrectly() {
		
		// Given
		// sut initialized with firstVisitor: false in init
		
		// When
		// Initial state
		
		// Then
		#expect(sut.state.isOnboarding == false)
		#expect(sut.state.isSearching == false)
		#expect(sut.state.results.isEmpty)
		#expect(sut.state.totalResults == 0)
		#expect(
			servicesSpies.searchOrganizationClientSpy.invokedPrepare == false
		)
	}
}
