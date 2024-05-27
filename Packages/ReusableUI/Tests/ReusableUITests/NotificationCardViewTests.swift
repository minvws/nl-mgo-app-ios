/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import SwiftUI
import XCTest
import SnapshotTesting

final class NotificationCardViewTests: XCTestCase {

	func test_notificationCard() throws {
		
		// Given
		let sut = NotificationCardView(icon: Image(systemName: "stethoscope"), title: "stethoscope", message: "info about stethoscope")
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
}
