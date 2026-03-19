/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
@testable import RemoteConfiguration

struct StringSemanticVersionTests {

	@Test("empty string should become 0.0.0")
	func semanticVersion_empty() {
		#expect("".semanticVersion() == "0.0.0")
	}

	@Test("single digit should become x.0.0")
	func semanticVersion_singleDigit() {
		#expect("1".semanticVersion() == "1.0.0")
	}

	@Test("two digits should become x.y.0")
	func semanticVersion_twoDigits() {
		#expect("2.1".semanticVersion() == "2.1.0")
	}

	@Test("three digits should be returned as-is")
	func semanticVersion_threeDigits() {
		#expect("2.1.8".semanticVersion() == "2.1.8")
	}

	@Test("four components should be returned as-is")
	func semanticVersion_fourDigits() {
		#expect("2.1.8.A".semanticVersion() == "2.1.8.A")
	}

	@Test("non-digit string should become x.0.0")
	func semanticVersion_noDigits() {
		#expect("🦠".semanticVersion() == "🦠.0.0")
	}
}
