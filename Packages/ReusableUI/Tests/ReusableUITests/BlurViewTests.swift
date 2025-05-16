/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
