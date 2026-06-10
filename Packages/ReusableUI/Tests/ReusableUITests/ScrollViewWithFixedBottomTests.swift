/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import SwiftUI
import MGOTest

@MainActor
final class ScrollViewWithFixedBottomTests: XCTestCase {

	func test_scrollViewWithFixedBottom_shortContent() throws {

		// Given
		let sut = ScrollViewWithFixedBottom(
			content: { Text(verbatim: "Short content") },
			bottomView: {
				Button(
					action: { /* no-op */ },
					label: {
						Text(verbatim: "Next")
							.frame(maxWidth: .infinity)
							.padding()
					}
				)
			}
		)

		// When
		let view = sut.frame(width: 390, height: 500)

		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}

	func test_scrollViewWithFixedBottom_longContent() throws {

		// Given
		let sut = ScrollViewWithFixedBottom(
			content: {
				VStack(spacing: 0) {
					ForEach(0..<30, id: \.self) { index in
						Text(verbatim: "Row \(index)")
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.horizontal)
							.padding(.vertical, 8)
					}
				}
			},
			bottomView: {
				Button(
					action: { /* no-op */ },
					label: {
						Text(verbatim: "Next")
							.frame(maxWidth: .infinity)
							.padding()
					}
				)
			}
		)

		// When
		let view = sut.frame(width: 390, height: 500)

		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}
}
