/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
