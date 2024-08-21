/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import ParsingCore

final class ParsingCoreTests: XCTestCase {
	
	var sut: FHIRParser!
	
	override func setUp() {
		super.setUp()
		sut = FHIRParser()
	}
	
	func test_getBundleResourcesJson() throws {
		
		// Given
		let json = try getResource("bundle")
		
		// When
		let result = sut.getBundleResourcesJson(json)
		
		// Then
		expect(result).to(haveCount(2))
	}
}
