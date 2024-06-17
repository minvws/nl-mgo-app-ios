/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import FHIRExtensions

final class ObservationEffectiveDateTests: XCTestCase {

	func test_observation_effectiveDate_1() throws {
		
		// Given
		let json = try getResource("stu3-observation-1")
		let observation = try Resource.fromJSON(json, type: Observation.self)
		
		// When
		let date = observation.effectiveDate
		
		// Then
		expect(date) == "2012-05-23T12:00:00+02:00"
	}
}
