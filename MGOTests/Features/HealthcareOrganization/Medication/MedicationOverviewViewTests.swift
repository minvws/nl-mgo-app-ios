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

final class MedicationOverviewViewTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: MedicationOverviewViewModel!
	private var healthcareOrganization: MgoOrganization!
	private var repositorySpy: MedicationUseRepositorySpy!
	private var sut: MedicationOverviewView!
	
	override func setUp() {
		
		super.setUp()
		repositorySpy = MedicationUseRepositorySpy()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1")
		viewModel = MedicationOverviewViewModel(coordinator: coordinatorSpy, healthcareOrganization: healthcareOrganization, repository: repositorySpy)
		sut = MedicationOverviewView(viewModel: self.viewModel)
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
		let block1 = OverviewBlock(heading: "Zestril tablet 10mg", subHeading: "Tandarts Tandje Erbij", action: nil)
		let block2 = OverviewBlock(heading: "Zestril tablet 10mg", subHeading: "Tandarts Tandje Erbij", action: nil)
		let block3 = OverviewBlock(heading: "Zestril tablet 10mg", subHeading: "Tandarts Tandje Erbij", action: nil)
		
		viewModel.state = .success(items: [block1, block2, block3])
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}

}
