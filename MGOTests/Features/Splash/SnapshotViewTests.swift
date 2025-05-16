/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
