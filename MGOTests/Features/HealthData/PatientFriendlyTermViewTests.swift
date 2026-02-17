/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOTest
@testable import MGO
import MGOUI
import MGOFoundation

final class PatientFriendlyTermViewTests: XCTestCase {
	
	private var viewModel: PatientFriendlyTermViewModel!
	private var sut: PatientFriendlyTermView!
	
	private let term = PatientFriendlyTerm(
		name: "Patient Vriendelijke Term",
		description: "Een langere omschrijving van een paar regels wat deze term inhoud.",
		synonym: "een andere benaming voor deze term"
	)
	
	@MainActor func createSut() {
		viewModel = PatientFriendlyTermViewModel(onClose: nil, term: term)
		sut = PatientFriendlyTermView(viewModel: self.viewModel)
	}
	
	@MainActor func test_PatientFriendlyTermView() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		createSut()
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut.isPresentedAsSheet(false) }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_PatientFriendlyTermView_iOS18() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		createSut()
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut.isPresentedAsSheet(false) }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_PatientFriendlyTermView_asSheet() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		createSut()
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut.isPresentedAsSheet(true) }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_PatientFriendlyTermView_iOS18_asSheet() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		createSut()
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut.isPresentedAsSheet(true) }
		
		// Then
		takeSnapShots(content: content)
	}
}
