/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest
import Nimble
@testable import FHIRExtensions

final class ObservationCodeTests: XCTestCase {

	func test_observation_code_1() throws {
		
		// Given
		let json = try getResource("stu3-observation-1")
		let observation = try Resource.fromJSON(json, type: Observation.self)
		
		// When
		let text = observation.codeText
		
		// Then
		expect(text) == "Chloride [mol/volume] in bloed"
	}
}
