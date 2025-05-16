/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import RemoteConfiguration

final class AppVersionSupplierTests: XCTestCase {
	
	func test_buildAndVersion() {
		
		// Given
		let sut = AppVersionSupplier()
		
		// When
		let version = sut.getCurrentVersion()
		let build = sut.getCurrentBuild()
		
		// Then
		expect(version) != "1.0.0"
		expect(build) != "1"
	}
}
