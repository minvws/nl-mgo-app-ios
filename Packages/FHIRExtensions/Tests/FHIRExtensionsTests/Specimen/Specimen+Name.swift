/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest
import Nimble
@testable import FHIRExtensions

final class SpecimenNameTests: XCTestCase {

	func test_specimen_name() throws {
		
		// Given
		let json = try getResource("stu3-specimen")
		let specimen = try Resource.fromJSON(json, type: Specimen.self)
		
		// When
		let name = specimen.name
		
		// Then
		expect(name) == "Bloed (substantie)"
	}
}
