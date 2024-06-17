/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import FHIRExtensions

final class ObservationQuantityTests: XCTestCase {

	func test_observation_quantity_1() throws {
		
		// Given
		let json = try getResource("stu3-observation-1")
		let observation = try Resource.fromJSON(json, type: Observation.self)
		
		// When
		let quantityText = observation.quantityText
		let referenceLowText = observation.referenceLowText
		let referenceHighText = observation.referenceHighText
		
		// Then
		expect(quantityText) == "109 mmol/l"
		expect(referenceLowText) == "99 mmol/l"
		expect(referenceHighText) == "108 mmol/l"
	}
}
