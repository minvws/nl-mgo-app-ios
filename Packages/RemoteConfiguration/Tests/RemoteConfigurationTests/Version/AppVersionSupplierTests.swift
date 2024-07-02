/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
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
