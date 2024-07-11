/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class ProblemsListViewTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: ProblemsListViewModel!
	private var healthcareOrganization: MgoOrganization!
	private var repositorySpy: ConcernRepositorySpy!
	private var sut: ProblemsListView!
	
	override func setUp() {
		
		super.setUp()
		repositorySpy = ConcernRepositorySpy()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1")
		viewModel = ProblemsListViewModel(coordinator: coordinatorSpy, healthcareOrganization: healthcareOrganization, repository: repositorySpy)
		sut = ProblemsListView(viewModel: self.viewModel)
	}

	func test_stateLoading() {
		
		// Given
		viewModel.state = .loading
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	func test_stateEmpty() {
		
		// Given
		viewModel.state = .empty
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_stateFailure() {
		
		// Given
		viewModel.state = .failure
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}

	func test_stateList() {
		
		// Given
		let concern = Generator.concern()
		viewModel.state = .success(items: [concern, concern, concern], startOpen: false)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_stateList_startOpen() {
		
		// Given
		let concern = Generator.concern()
		viewModel.state = .success(items: [concern, concern, concern], startOpen: true)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
