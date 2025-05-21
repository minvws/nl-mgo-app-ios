/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO
import RemoteConfiguration

final class AppVersionSupplierTests: XCTestCase {
	
	func test_buildAndVersion() {
		
		// Given
		let sut = AppVersionSupplier()
		
		// When
		let version = sut.getCurrentVersion()
		let build = sut.getCurrentBuild()
		
		// Then
		expect(version) == "0.0.1"
		expect(build) == "1"
	}
}
