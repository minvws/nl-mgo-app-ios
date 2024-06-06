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

final class LabResultsListViewTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: LabResultsListViewModel!
	private var healthcareProvider: HealthcareProvider!
	private var repositorySpy: LaboratoryTestResultRepositorySpy!
	private var sut: LabResultsListView!
	
	override func setUp() {
		
		super.setUp()
		repositorySpy = LaboratoryTestResultRepositorySpy()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareProvider = Generator.healthcareProvider("1")
		viewModel = LabResultsListViewModel(coordinator: coordinatorSpy, healthcareProvider: healthcareProvider, repository: repositorySpy)
		sut = LabResultsListView(viewModel: self.viewModel)
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
		let labResult = Generator.labResult()
		viewModel.state = .success([labResult, labResult, labResult])
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
