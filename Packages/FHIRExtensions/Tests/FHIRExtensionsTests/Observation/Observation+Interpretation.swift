/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import FHIRExtensions

final class ObservationInterpretationTests: XCTestCase {

	func test_observation_interpretation_1() throws {
		
		// Given
		let json = try getResource("stu3-observation-1")
		let observation = try Resource.fromJSON(json, type: Observation.self)
		
		// When
		let text = observation.interpretationText
		
		// Then
		expect(text) == "boven referentiebereik (kwalificatiewaarde)"
	}
}
