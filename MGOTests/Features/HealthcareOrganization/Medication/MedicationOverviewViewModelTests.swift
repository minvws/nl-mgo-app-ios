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
import Zibs

final class MedicationOverviewViewModelTests: XCTestCase {
	
//	private var coordinatorSpy: DashboardCoordinatorSpy!
//	private var servicesSpies: ServicesSpies!
//	private var sut: MedicationOverviewViewModel!
//	private var healthcareOrganization: MgoOrganization!
//	private var repositorySpy: MedicationUseRepositorySpy!
//	
//	override func setUp() {
//		
//		super.setUp()
//		repositorySpy = MedicationUseRepositorySpy()
//		servicesSpies = setupServicesSpies()
//		coordinatorSpy = DashboardCoordinatorSpy()
//		healthcareOrganization = Generator.healthcareOrganization("1")
//		sut = MedicationOverviewViewModel(coordinator: coordinatorSpy, healthcareOrganization: healthcareOrganization, repository: repositorySpy)
//	}
//	
//	func test_initialState_shouldBeLoading() {
//		
//		// Given
//		
//		// When
//		
//		// Then
//		expect(self.sut.state) == MedicationOverviewViewState.loading
//	}
//	
//	func test_initialState_noRepository_shouldBeFailure() {
//		
//		// Given
//		sut = MedicationOverviewViewModel(coordinator: coordinatorSpy, healthcareOrganization: healthcareOrganization, repository: nil)
//		
//		// When
//		
//		// Then
//		expect(self.sut.state) == MedicationOverviewViewState.failure
//	}
//	
//	func test_backButtonPressed_shouldCallCoordinator() {
//		
//		// Given
//		
//		// When
//		sut.reduce(.backButtonPressed)
//		
//		// Then
//		expect(self.coordinatorSpy.invokedHandle) == true
//		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
//	}
//	
//	func test_loadMedications_noResults() {
//		
//		// Given
//		repositorySpy.stubbedFetchMedicationUse = []
//		
//		// When
//		sut.reduce(.onAppear)
//		
//		// Then
//		expect(self.sut.state).toEventually(equal(MedicationOverviewViewState.empty))
//	}
//	
//	func test_loadMedications_throwsError() {
//		
//		// Given
//		repositorySpy.stubbedError = NSError(domain: "MedicationListViewModelTests", code: 404)
//		
//		// When
//		sut.reduce(.onAppear)
//		
//		// Then
//		expect(self.sut.state).toEventually(equal(MedicationOverviewViewState.failure))
//	}
//	
//	func test_loadMedications_invalidService() {
//		
//		// Given
//		healthcareOrganization = Generator.healthcareOrganization("1", useDataService: false)
//		sut = MedicationOverviewViewModel(coordinator: coordinatorSpy, healthcareOrganization: healthcareOrganization, repository: repositorySpy)
//		
//		// When
//		sut.reduce(.onAppear)
//		
//		// Then
//		expect(self.sut.state).toEventually(equal(MedicationOverviewViewState.empty))
//	}
//
//	func test_loadMedications_result() {
//		
//		// Given
//		let zibMedicationUse = Generator.medicationUse()
//		let schema = UISchema(children: [], label: "demo schema")
//
//		repositorySpy.stubbedFetchMedicationUse = [
//			ZibSchema(zib: zibMedicationUse, schema: schema)
//		]
//		
//		// When
//		sut.reduce(.onAppear)
//		
//		// Then
//		expect(self.sut.state).toEventuallyNot(equal(MedicationOverviewViewState.loading))
//		if case let MedicationOverviewViewState.success(items) = sut.state {
//			
//			expect(items.first?.heading) == "demo schema"
//			expect(items.first?.subHeading) == "Tandarts Tandje Erbij"
//
//		} else {
//			fail("wrong state")
//		}
//	}
}
