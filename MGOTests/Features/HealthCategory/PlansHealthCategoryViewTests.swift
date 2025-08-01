/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class PlansHealthCategoryViewTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: HealthCategoryViewModel!
	private var healthcareOrganization: MgoOrganization!
	private var sut: HealthCategoryView!
	
	private let item = Generator.healthSubCategory()
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1")
	}
	
	@MainActor private func createSut() {
		
		viewModel = PlansHealthCategoryViewModel(
			coordinator: coordinatorSpy,
			organization: healthcareOrganization)
		sut = HealthCategoryView(viewModel: self.viewModel)
	}
	
	@MainActor func test_stateLoading() {
		
		// Given
		createSut()
		viewModel.state = .loading
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	@MainActor func test_stateEmptyList() {
		
		// Given
		createSut()
		let content = NavigationView { sut }
		
		// When
		sut.viewModel.state = .list(items: [])
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_stateEmptyPartialList() {
		
		// Given
		createSut()
		let content = NavigationView { sut }
		
		// When
		sut.viewModel.state = .partial(items: [])
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_stateList() throws {
		
		// Given
		createSut()
		let content = NavigationView { sut }
		
		// When
		sut.viewModel.state = .list(items: [item])
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func disabled_test_search_itemNotFound() throws {
		
		// Given
		createSut()
		let content = NavigationView { sut }
		sut.viewModel.state = .list(items: [item])
		
		// When
		viewModel.searchText = "MGO"
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func disabled_test_search_itemFound() throws {
		
		// Given
		createSut()
		let content = NavigationView { sut }
		sut.viewModel.state = .list(items: [item])
		
		// When
		viewModel.searchText = "health"
		
		// Then
		takeSnapShots(content: content)
	}
}
