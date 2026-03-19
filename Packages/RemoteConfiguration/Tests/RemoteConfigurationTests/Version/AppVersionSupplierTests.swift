/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
@testable import RemoteConfiguration

struct AppVersionSupplierTests {

	@Test("build and version should not be the default placeholder values")
	func buildAndVersion() {
		let sut = AppVersionSupplier()
		#expect(sut.getCurrentVersion() != "1.0.0")
		#expect(sut.getCurrentBuild() != "1")
	}
}
