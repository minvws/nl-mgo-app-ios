/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOTest
@testable import MGO
import MGOUI
import PatientFriendlyTerms

final class PatientFriendlyTermViewTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var viewModel: PatientFriendlyTermViewModel!
	private var sut: PatientFriendlyTermView!
	
	private let term = PatientFriendlyTerm(
		name: "Patient Vriendelijke Term",
		description: "Een langere omschrijving van een paar regels wat deze term inhoud.",
		synonym: "een andere benaming voor deze term"
	)
	
	override func setUp() {
		
		super.setUp()
		coordinatorSpy = DashboardCoordinatorSpy()
	}
	
	@MainActor func createSut() {
		viewModel = PatientFriendlyTermViewModel(coordinator: coordinatorSpy, term: term)
		sut = PatientFriendlyTermView(viewModel: self.viewModel)
	}
	
	@MainActor func test_PatientFriendlyTermView() throws {
		
		// Given
		createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
