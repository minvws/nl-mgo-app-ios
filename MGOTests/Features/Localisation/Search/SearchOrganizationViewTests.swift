/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@preconcurrency import MGOTest
@testable import MGO
import MGOFoundation
import MGOUI
import OrganizationSearch

final class SearchOrganizationViewTests: XCTestCase {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: SearchOrganizationViewModel!
	private var sut: SearchOrganizationView!
	
	override func setUpWithError() throws {
		
		try super.setUpWithError()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
	}
	
	@MainActor private func createSut(firstVisitor: Bool = false, input: String = "") {
		
		viewModel = SearchOrganizationViewModel(
			coordinator: coordinatorSpy,
			firstVisitor: firstVisitor
		)
		sut = SearchOrganizationView(viewModel: self.viewModel, input: input)
	}
	
	// MARK: - Snapshot Tests
	
	@MainActor func test_snapshot_noSearch() {
		
		// Given
		createSut(firstVisitor: false)
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
			.environment(\.isPresentedAsSheet, false)
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_snapshot_shortSearchTerm() {
		
		// Given
		createSut(firstVisitor: false, input: "AB")
		viewModel.state.results = []
		viewModel.state.totalResults = 0
		viewModel.state.isSearching = false
		
		// When
		// Simulate short search term by setting state manually
		// The view will show empty state because search term is too short
		let content = NavigationStackBackport.NavigationStack { sut }
			.environment(\.isPresentedAsSheet, false)
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_snapshot_searchWithThreeResults() async throws {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [
			Generator.healthcareOrganization("org-1")
		]
		
		createSut(firstVisitor: false, input: "Test")
		
		// Create three mock organizations
		let organization1 = Generator.searchOrganization(
			id: "org-1",
			displayName: "Test Hospital Amsterdam",
			city: "Amsterdam",
			addressLine: "Hoofdstraat 123",
			postalCode: "1012AB",
			dataServices: [
				"50": OrganizationSearch.DataService(
					authEndpoint: "test",
					resourceEndpoint: "test",
					tokenEndpoint: "test"
				)
			]
		)
		
		let organization2 = Generator.searchOrganization(
			id: "org-2",
			displayName: "Test Clinic Rotterdam",
			city: "Rotterdam",
			addressLine: "Testweg 456",
			postalCode: "3011CD",
			dataServices: [
				"9999999": OrganizationSearch.DataService(
					authEndpoint: "test",
					resourceEndpoint: "test",
					tokenEndpoint: "test"
				)
			]
		)
		
		let organization3 = Generator.searchOrganization(
			id: "org-3",
			displayName: "Test Medical Center Utrecht",
			city: "Utrecht",
			addressLine: "Testlaan 789",
			postalCode: "3511EF",
			dataServices: [
				"50": OrganizationSearch.DataService(
					authEndpoint: "test",
					resourceEndpoint: "test",
					tokenEndpoint: "test"
				)
			]
		)
		
		// Create search results with three hits
		let searchResults = SearchResults(
			count: 3.0,
			hits: [
				SearchResult(document: organization1, id: "org-1", score: 0.95),
				SearchResult(document: organization2, id: "org-2", score: 0.85),
				SearchResult(document: organization3, id: "org-3", score: 0.75)
			]
		)
		
		// Stub the search client to return three results
		servicesSpies.searchOrganizationClientSpy.stubbedSearchHealthcareOrganizationsSearchResults = searchResults
		
		// Set the state to show results
		viewModel.state.results = searchResults.hits.map { $0.document }
		viewModel.state.totalResults = Int(searchResults.count)
		viewModel.state.isSearching = false
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
			.environment(\.isPresentedAsSheet, false)
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_snapshot_searchWithNoResults() async throws {
		
		// Given
		createSut(firstVisitor: false, input: "Test")
		servicesSpies.searchOrganizationClientSpy.stubbedSearchHealthcareOrganizationsSearchResults = SearchResults(
			count: 0.0,
			hits: []
		)
		viewModel.state.results = []
		viewModel.state.totalResults = 0
		viewModel.state.isSearching = false
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
			.environment(\.isPresentedAsSheet, false)
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_select_organization() async throws {
		
		// Given
		createSut(firstVisitor: false, input: "Test")
		
		// Create a mock organization
		let organization1 = Generator.searchOrganization(
			id: "org-1",
			displayName: "Test Hospital Amsterdam",
			city: "Amsterdam",
			addressLine: "Hoofdstraat 123",
			postalCode: "1012AB",
			dataServices: [
				"50": OrganizationSearch.DataService(
					authEndpoint: "test",
					resourceEndpoint: "test",
					tokenEndpoint: "test"
				)
			]
		)
		
		// Create search results with three hits
		let searchResults = SearchResults(
			count: 1.0,
			hits: [
				SearchResult(document: organization1, id: "org-1", score: 0.95)
			]
		)
		
		// Stub the search client to return three results
		servicesSpies.searchOrganizationClientSpy.stubbedSearchHealthcareOrganizationsSearchResults = searchResults
		
		// Set the state to show results
		viewModel.state.results = searchResults.hits.map { $0.document }
		viewModel.state.totalResults = Int(searchResults.count)
		viewModel.state.isSearching = false
		
		// When
		try sut.inspect().find(viewWithAccessibilityIdentifier: "button_org-1")
			.button().tap()
		
		// Then
		takeSnapShots(content: sut)
	}
	
	@MainActor func test_snapshot_firstVisitorOnboarding() {
		
		// Given
		createSut(firstVisitor: true)
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
			.environment(\.isPresentedAsSheet, false)
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_snapshot_searchingState() {
		
		// Given
		createSut(firstVisitor: false)
		viewModel.state.isSearching = true
		viewModel.state.results = []
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
			.environment(\.isPresentedAsSheet, false)
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_snapshot_searchingState_isPresentedAsSheet() {
		
		// Given
		createSut(firstVisitor: false)
		viewModel.state.isSearching = true
		viewModel.state.results = []
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
			.environment(\.isPresentedAsSheet, true)
		
		// Then
		takeSnapShots(content: content)
	}
}
