/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
import MGOUI
@testable import MGO
import SnapshotTesting

final class BackButtonTests: XCTestCase {
	
	@MainActor func test_layout_iOS18() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		
		// When
		let sut = BackButton(action: nil).frame(width: 300, height: 50)
		
		// Then
		assertSnapshot(of: sut, as: .image)
	}
	
	@MainActor func test_action_iOS18() async throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		var actionTapped = false
		
		// When
		let sut = BackButton(action: { actionTapped = true })
		try sut.inspect().find(viewWithAccessibilityIdentifier: "common.previous").button().tap()
		
		// Then
		await expect(actionTapped).toEventually(beTrue())
	}
	
	@MainActor func test_layout_iOS26() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		
		// When
		let sut = BackButton(action: nil).frame(width: 300, height: 50)
		
		// Then
		assertSnapshot(of: sut, as: .image)
	}
	
	@MainActor func test_action_iOS26() async throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		var actionTapped = false
		
		// When
		let sut = BackButton(action: { actionTapped = true })
		try sut.inspect().find(viewWithAccessibilityIdentifier: "common.previous").button().tap()
		
		// Then
		await expect(actionTapped).toEventually(beTrue())
	}
}
