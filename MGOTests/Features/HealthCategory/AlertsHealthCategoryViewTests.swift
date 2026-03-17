/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

class AlertsHealthCategoryViewTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var healthcareOrganization: OrganizationSearch.Organization!
	private var sut: HealthCategoryView!
	private var categoryId: String!
	
	private let item = Generator.healthCategoryBlock()
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1")
	}
	
	@MainActor func createSut(
		_ categoryId: String = "alerts",
		state: HealthCategoryViewState
	) throws {

		self.categoryId = categoryId
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(
			sharedCategories.findCategory(
				id: categoryId
			)
		)
		let translations = try XCTUnwrap(
			HealthCategoryViewTranslationsFactory.makeTranslations(
				for: category
			)
		)

		// Stub the data store to failure so the onAppear-triggered loadResources(threshold: 0)
		// exits early and does not animate over the state set for the snapshot.
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .failure(DataStoreError.noData)

		let viewModel = HealthCategoryViewModel(
			coordinator: coordinatorSpy,
			category: category,
			organization: healthcareOrganization,
			translations: translations
		)
		viewModel.state = state
		sut = HealthCategoryView(viewModel: viewModel)
	}
	
	@MainActor func test_stateLoading() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		try createSut(state: .loading)
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(
			content: content,
			name: "\(categoryId)_\(#function)",
			precision: 0.75
		)
	}
	
	@MainActor func test_stateEmptyListNoError() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		try createSut(state: .list(items: [], errorState: .none))
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content, name: "\(categoryId)_\(#function)")
	}
	
	@MainActor func test_stateEmptyListLoadingState() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		try createSut(state: .list(items: [], errorState: .loading))
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(
			content: content,
			name: "\(categoryId)_\(#function)",
			precision: 0.75
		)
	}
	
	@MainActor func test_stateEmptyListErrorState() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		try createSut(state: .list(
			items: [],
			errorState: .error(
				heading: "Error",
				subHeading: "Er is een fout opgetreden"
			)
		))
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content, name: "\(categoryId)_\(#function)")
	}
	
	@MainActor func test_stateNotEmptyListNoError() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		try createSut(state: .list(items: [item], errorState: .none))
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content, name: "\(categoryId)_\(#function)")
	}
	
	@MainActor func test_stateNotEmptyListsNoError() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		try createSut(state: .list(items: [item, item, item], errorState: .none))
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content, name: "\(categoryId)_\(#function)")
	}
	
	@MainActor func test_stateNotEmptyListLoadingState() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		try createSut(state: .list(items: [item], errorState: .loading))
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(
			content: content,
			name: "\(categoryId)_\(#function)",
			precision: 0.75
		)
	}
	
	@MainActor func test_stateNotEmptyListErrorState() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		try createSut(state: .list(
			items: [item],
			errorState: .error(
				heading: "Error",
				subHeading: "Er is een fout opgetreden"
			)
		))
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content, name: "\(categoryId)_\(#function)")
	}
	
	@MainActor func test_stateNotEmptyListNoError_iOS26() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		try createSut(state: .list(items: [item], errorState: .none))
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content, name: "\(categoryId)_\(#function)")
	}
	
	@MainActor func test_stateNotEmptyListsNoError_iOS26() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		try createSut(state: .list(items: [item, item, item], errorState: .none))
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content, name: "\(categoryId)_\(#function)")
	}
	
	@MainActor func test_stateNotEmptyListLoadingState_iOS26() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		try createSut(state: .list(items: [item], errorState: .loading))
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(
			content: content,
			name: "\(categoryId)_\(#function)",
			precision: 0.75
		)
	}
	
	@MainActor func test_stateNotEmptyListErrorState_iOS26() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		try createSut(state: .list(
			items: [item],
			errorState: .error(
				heading: "Error",
				subHeading: "Er is een fout opgetreden"
			)
		))
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content, name: "\(categoryId)_\(#function)")
	}
}
