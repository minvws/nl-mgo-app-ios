/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
import MGOUI
@testable import MGO
import SnapshotTesting

final class ErrorViewTests: XCTestCase {

	@MainActor func test_layout_iOS18() {

		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }

		// When
		let sut = ErrorView(viewModel: ErrorViewModel(action: {}))
			.frame(width: 390, height: 844)

		// Then
		assertSnapshot(of: sut, as: .image)
	}

	@MainActor func test_layout_iOS26() {

		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }

		// When
		let sut = ErrorView(viewModel: ErrorViewModel(action: {}))
			.frame(width: 390, height: 844)

		// Then
		assertSnapshot(of: sut, as: .image)
	}

	@MainActor func test_actionButton_callsAction() throws {

		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		var actionCalled = false

		// When
		let sut = ErrorView(viewModel: ErrorViewModel(action: { actionCalled = true }))
		try sut.inspect().find(viewWithAccessibilityIdentifier: "action_button").button().tap()

		// Then
		expect(actionCalled) == true
	}
}
