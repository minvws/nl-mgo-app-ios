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

final class ProblemsListViewModelTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: ProblemsListViewModel!
	private var healthcareProvider: HealthcareProvider!
	private var repositorySpy: ConcernRepositorySpy!

	override func setUp() {
		
		super.setUp()
		repositorySpy = ConcernRepositorySpy()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareProvider = Generator.healthcareProvider("1")
		sut = ProblemsListViewModel(coordinator: coordinatorSpy, healthcareProvider: healthcareProvider, repository: repositorySpy)
	}
	
	func test_initialState_shouldBeLoading() {
		
		// Given
		
		// When
		
		// Then
		expect(self.sut.state) == ProblemsListViewState.loading
	}
	
	func test_initialState_noRepository_shouldBeFailure() {
		
		// Given
		sut = ProblemsListViewModel(coordinator: coordinatorSpy, healthcareProvider: healthcareProvider, repository: nil)
		
		// When
		
		// Then
		expect(self.sut.state) == ProblemsListViewState.failure
	}
	
	func test_backButtonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
	
	func test_loadProblems_noResults() {
		
		// Given
		repositorySpy.stubbedFetchConcerns = []
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(ProblemsListViewState.empty))
	}
	
	func test_loadProblemss_throwsError() {
		
		// Given
		repositorySpy.stubbedError = NSError(domain: "MedicationListViewModelTests", code: 404)
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(ProblemsListViewState.failure))
	}

	func test_loadProblems_result() {

		// Given
		let concern = Generator.concern()
		repositorySpy.stubbedFetchConcerns = [
			concern
		]
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(ProblemsListViewState.success([concern])))
	}
}
