/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOUI
@testable import MGO

final class SnapshotViewTests: XCTestCase {
		
	func test_snapshot_withSpinner() {
	
		// Given
		let sut = SnapshotView(showSpinner: .constant(true))
		
		// When
		
		// Then
		takeSnapShots(content: sut, precision: 0.90)
	}
	
	func test_snapshot_withoutSpinner() {
		
		// Given
		let sut = SnapshotView(showSpinner: .constant(false))
		
		// When
		
		// Then
		takeSnapShots(content: sut)
	}
}
