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
	private var healthcareProvider: HealthcareProvider!
	private var repositorySpy: MedicationStatementRepositorySpy!
	private var sut: MedicationListView!
	
	override func setUp() {
		
		super.setUp()
		repositorySpy = MedicationStatementRepositorySpy()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareProvider = Generator.healthcareProvider("1")
		viewModel = MedicationListViewModel(coordinator: coordinatorSpy, healthcareProvider: healthcareProvider, repository: repositorySpy)
		sut = MedicationListView(viewModel: self.viewModel)
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
		let statement = MedicationStatement(
			dosage: [Dosage(text: "Vanaf 22 februari 2024, gedurende 30 dagen, zo nodig maal per dag 1 à 2 stuks , maximaal 6 stuks per dag, oraal")],
			effective: .period(Period(start: FHIRPrimitive<DateTime>("2024-02-21"))),
			medication: .reference(Reference(display: "PARACETAMOL TABLET 500MG", reference: "Medication/zib-Product-02")),
			status: FHIRPrimitive<MedicationStatementStatus>(.active),
			subject: Reference(display: "Johan XXX_Helleman", reference: "Patient/nl-core-patient-01"),
			taken: FHIRPrimitive<MedicationStatementTaken>(.unk)
		)
		viewModel.state = .success([statement, statement, statement])
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
