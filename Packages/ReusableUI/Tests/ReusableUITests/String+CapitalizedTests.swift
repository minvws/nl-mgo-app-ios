/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import SwiftUI
import Testing

struct StringCapitalizerTests {
	@Test
	func capitalizingFirstLetter() {
		#expect("hello".capitalizingFirstLetter() == "Hello")
		#expect("Hello".capitalizingFirstLetter() == "Hello")
		#expect("hEllO".capitalizingFirstLetter() == "Hello")
	}
}
