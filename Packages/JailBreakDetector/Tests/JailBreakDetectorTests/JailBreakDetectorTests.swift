/*
*  Copyright (c) 2023 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

@testable import JailBreakDetector
import MGOTest

class JailBreakTests: XCTestCase {

	private var sut: JailBreakDetector!

	override func setUp() {

		super.setUp()

		sut = JailBreakDetector()
	}

	func test_isJailBroken() {

		// Given
		// Can't simulate a jailbroken device.

		// When
		let result = sut.isJailBroken()

		// Then
		expect(result) == false
	}
}
