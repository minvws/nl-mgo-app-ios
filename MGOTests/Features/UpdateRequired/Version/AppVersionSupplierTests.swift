/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
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
