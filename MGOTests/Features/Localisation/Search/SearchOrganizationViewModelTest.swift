/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGO
import Testing
import OrganizationSearch

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
		sut.state.results = [createMockOrganization()]
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
		sut.state.results = [createMockOrganization()]
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
		sut.state.results = [createMockOrganization()]
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
	func reduce_search_withValidSearchTerm_shouldSetIsSearchingToTrue() {
		
		// Given
		sut.state.isSearching = false
		
		// When
		sut.reduce(.search("Test"))
		
		// Then
		#expect(sut.state.isSearching == true)
	}
	
	// MARK: - store Action Tests
	
	@Test("Reduce store should call coordinator to finish searching")
	func reduce_store_shouldCallCoordinatorToFinishSearching() {
		
		// Given
		let organization = createMockOrganization()
		
		// When
		sut.reduce(.store(organization))
		
		// Then
		#expect(
			servicesSpies.healthcareOrganizationStoreSpy.invokedStore == true
		)
		#expect(coordinatorSpy.invokedHandle == true)
		#expect(coordinatorSpy.invokedHandleParameters?.0 == Coordination.Action.finishedSearchingHealthcareOrganizations)
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
			servicesSpies.searchOrganizationClientSpy.invokedPrepare == true
		)
	}
	
	// MARK: - Helper Methods
	
	private func createMockOrganization(
		id: String = "test-id",
		displayName: String = "Test Organization",
		city: String = "Amsterdam",
		addressLine: String = "Test Street 123",
		postalCode: String = "1234AB",
		careTypeDisplay: String = "Hospital"
	) -> OrganizationSearch.Organization {
		return OrganizationSearch.Organization(
			addressLine: addressLine,
			careTypeDisplay: careTypeDisplay,
			city: city,
			dataServices: nil,
			displayName: displayName,
			geoLat: nil,
			geoLng: nil,
			id: id,
			normalizedDisplayName: displayName.lowercased(),
			postalCode: postalCode,
			searchBlob: nil
		)
	}
}
