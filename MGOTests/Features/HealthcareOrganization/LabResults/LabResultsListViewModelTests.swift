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

final class LabResultsListViewModelTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: LabResultsListViewModel!
	private var healthcareOrganization: MgoOrganization!
	private var repositorySpy: LaboratoryTestResultRepositorySpy!

	override func setUp() {
		
		super.setUp()
		repositorySpy = LaboratoryTestResultRepositorySpy()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1")
		sut = LabResultsListViewModel(coordinator: coordinatorSpy, healthcareOrganization: healthcareOrganization, repository: repositorySpy)
	}
	
	func test_initialState_shouldBeLoading() {
		
		// Given
		
		// When
		
		// Then
		expect(self.sut.state) == LabResultsListViewState.loading
	}
	
	func test_initialState_noRepository_shouldBeFailure() {
		
		// Given
		sut = LabResultsListViewModel(coordinator: coordinatorSpy, healthcareOrganization: healthcareOrganization, repository: nil)
		
		// When
		
		// Then
		expect(self.sut.state) == LabResultsListViewState.failure
	}
	
	func test_backButtonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
	
	func test_loadResults_noResults() {
		
		// Given
		repositorySpy.stubbedFetchResults = []
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(LabResultsListViewState.empty))
	}
	
	func test_loadResults_throwsError() {
		
		// Given
		repositorySpy.stubbedError = NSError(domain: "LabResultsListViewModelTests", code: 404)
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(LabResultsListViewState.failure))
	}

	func test_loadResults_invalidService() {
		
		// Given
		healthcareOrganization = Generator.healthcareOrganization("1", useDataService: false)
		sut = LabResultsListViewModel(coordinator: coordinatorSpy, healthcareOrganization: healthcareOrganization, repository: repositorySpy)
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(LabResultsListViewState.empty))
	}
	
	func test_loadResults_result() {
		
		// Given
		let labResult = Generator.labResult()
		repositorySpy.stubbedFetchResults = [
			labResult
		]
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(LabResultsListViewState.success(items: [labResult], startOpen: false)))
	}
}
