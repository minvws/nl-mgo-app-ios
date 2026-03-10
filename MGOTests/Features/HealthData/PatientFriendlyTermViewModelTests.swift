/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOTest
@testable import MGO
import MGOFoundation

final class PatientFriendlyTermViewModelTests: XCTestCase {
	
	private var sut: PatientFriendlyTermViewModel!
	private let term = PatientFriendlyTerm(
		name: "Patient Vriendelijke Term",
		description: "Een langere omschrijving van een paar regels wat deze term inhoud.",
		synonym: "een andere benaming voor deze term"
	)
	
	@MainActor func test_reduce_closeSheet() async {
		
		// Given
		var onClosePressed = false
		sut = PatientFriendlyTermViewModel(onClose: { onClosePressed = true }, term: term)
		
		// When
		sut.reduce(.closeSheet)
		
		// Then
		expect(onClosePressed) == true
	}
}
