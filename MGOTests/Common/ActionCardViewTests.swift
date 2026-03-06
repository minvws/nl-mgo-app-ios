/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOUI
@testable import MGO
import SnapshotTesting

final class ActionCardViewTests: XCTestCase {

	@MainActor func test_layout() {

		// When
		let sut = ActionCardView(title: "Title", message: "Message")
			.frame(width: 390)

		// Then
		assertSnapshot(of: sut, as: .image)
	}

	@MainActor func test_perform_callsAction() {

		// Given
		var actionCalled = false

		// When
		let sut = ActionCardView(title: "Title", message: "Message", perform: { actionCalled = true })
		sut.perform?()

		// Then
		expect(actionCalled) == true
	}
}
