/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest
import Nimble
@testable import FHIRExtensions

final class SpecimenCollectedDateTests: XCTestCase {

	func test_specimen_collectedDate() throws {
		
		// Given
		let json = try getResource("stu3-specimen")
		let specimen = try Resource.fromJSON(json, type: Specimen.self)
		
		// When
		let collectedDate = specimen.collectedDate
		
		// Then
		expect(collectedDate) == "2012-05-23T08:08:00+02:00"
	}
}
