/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOTest
@testable import MGO
import PatientFriendlyTerms

final class PatientFriendlyTermViewModelTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var sut: PatientFriendlyTermViewModel!
	private let term = PatientFriendlyTerm(
		name: "Patient Vriendelijke Term",
		description: "Een langere omschrijving van een paar regels wat deze term inhoud.",
		synonym: "een andere benaming voor deze term"
	)
	
	override func setUp() {
		
		super.setUp()
		coordinatorSpy = DashboardCoordinatorSpy()
	}
	
	@MainActor func test_reduce_closeSheet() {
		
		// Given
		sut = PatientFriendlyTermViewModel(coordinator: coordinatorSpy, term: term)
		
		// When
		sut.reduce(.closeSheet)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.closeSheet
	}
}
