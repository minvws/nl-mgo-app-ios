/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class AlertsHealthCategoryViewTests: XCTestCase {
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: HealthCategoryViewModel!
	private var healthcareOrganization: MgoOrganization!
	private var sut: HealthCategoryView!
	
	private let item = Generator.healthCategoryBlock()
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1")
	}
	
	@MainActor private func createSut() throws {

		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: "alerts"))
		let translations = try XCTUnwrap(HealthCategoryViewTranslationsFactory.makeTranslations(for: category))
		
		viewModel = HealthCategoryViewModel(
			coordinator: coordinatorSpy,
			category: category,
			organization: healthcareOrganization,
			translations: translations
		)
		sut = HealthCategoryView(viewModel: self.viewModel)
	}
	
	@MainActor func test_stateLoading() throws {
		
		// Given
		try createSut()
		viewModel.state = .loading
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	@MainActor func test_stateEmptyList() throws {
		
		// Given
		try createSut()
		let content = NavigationView { sut }
		
		// When
		viewModel.state = .list(items: [])
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_stateEmptyPartialList() throws {
		
		// Given
		try createSut()
		let content = NavigationView { sut }
		
		// When
		viewModel.state = .partial(items: [])
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_stateList() throws {
		
		// Given
		try createSut()
		let content = NavigationView { sut }
		
		// When
		viewModel.state = .list(items: [item])
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func disabled_test_search_itemNotFound() throws {
		
		// Given
		try createSut()
		let content = NavigationView { sut }
		viewModel.state = .list(items: [item])
		
		// When
		viewModel.searchText = "MGO"
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func disabled_test_search_itemFound() throws {
		
		// Given
		try createSut()
		let content = NavigationView { sut }
		viewModel.state = .list(items: [item])
		
		// When
		viewModel.searchText = "health"
		
		// Then
		takeSnapShots(content: content)
	}
}
