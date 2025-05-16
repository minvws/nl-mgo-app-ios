/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class LifestyleHealthCategoryViewTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: HealthCategoryViewModel!
	private var healthcareOrganization: MgoOrganization!
	private var sut: HealthCategoryView!
	
	private let item = HealthSubCategory(
		heading: "heading subcategory",
		rows: [
			HealthCategoryRow(heading: "heading", subHeading: "healthcare organization", action: nil)
		]
	)

	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1")
		viewModel = LifestyleHealthCategoryViewModel(
			coordinator: coordinatorSpy,
			organization: healthcareOrganization)
		sut = HealthCategoryView(viewModel: self.viewModel)
	}

	func test_stateLoading() {
		
		// Given
		viewModel.state = .loading
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	func test_stateEmptyList() {
		
		// Given
		let content = NavigationView { sut }
		
		// When
		sut.viewModel.state = .list(items: [])
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_stateEmptyPartialList() {
		
		// Given
		let content = NavigationView { sut }
		
		// When
		sut.viewModel.state = .partial(items: [])
		
		// Then
		takeSnapShots(content: content)
	}

	func test_stateList() throws {
		
		// Given
		let content = NavigationView { sut }
		
		// When
		sut.viewModel.state = .list(items: [item])
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_search_itemNotFound() throws {
		
		// Given
		let content = NavigationView { sut }
		sut.viewModel.state = .list(items: [item])
		
		// When
		viewModel.searchText = "MGO"
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_search_itemFound() throws {
		
		// Given
		let content = NavigationView { sut }
		sut.viewModel.state = .list(items: [item])
		
		// When
		viewModel.searchText = "health"
		
		// Then
		takeSnapShots(content: content)
	}
}
