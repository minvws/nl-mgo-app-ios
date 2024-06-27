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

final class MedicationListViewTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: MedicationListViewModel!
	private var healthcareOrganization: HealthcareOrganization!
	private var repositorySpy: MedicationUseRepositorySpy!
	private var sut: MedicationListView!
	
	override func setUp() {
		
		super.setUp()
		repositorySpy = MedicationUseRepositorySpy()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1")
		viewModel = MedicationListViewModel(coordinator: coordinatorSpy, healthcareOrganization: healthcareOrganization, repository: repositorySpy)
		sut = MedicationListView(viewModel: self.viewModel)
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
		let statement = Generator.medicationUse()
		viewModel.state = .success(items: [statement, statement, statement], startOpen: false)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_stateList_startOpen() {
		
		// Given
		let statement = Generator.medicationUse()
		viewModel.state = .success(items: [statement, statement, statement], startOpen: true)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
