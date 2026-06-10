/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOUI
import SwiftUI

@MainActor
final class MGOLottieViewTests: XCTestCase {

	private struct Container: View {
		let animationName: String
		let aspectRatio: CGFloat

		var body: some View {
			MGOLottieView(animationName, aspectRatio: aspectRatio)
		}
	}

	func test_isFoundInHierarchy() throws {

		// Given
		let sut = Container(animationName: "any_animation", aspectRatio: 1)

		// When / Then — MGOLottieView is reachable inside its parent
		_ = try sut.inspect().find(MGOLottieView.self)
	}

	func test_body_inspectable() throws {

		// Given
		let sut = MGOLottieView("any_animation", aspectRatio: 1.5)

		// When / Then — the wrapper's body resolves without throwing
		_ = try sut.inspect()
	}
}
