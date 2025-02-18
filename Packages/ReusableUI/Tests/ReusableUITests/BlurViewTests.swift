/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import SwiftUI
import MGOTest

final class BlurViewTests: XCTestCase {

	func test_blurView() throws {
		
		// Given
		
		let sut = DetailRow(title: "Title", content: "Content")
			.background(BlurView(style: .systemUltraThinMaterial))
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
}
