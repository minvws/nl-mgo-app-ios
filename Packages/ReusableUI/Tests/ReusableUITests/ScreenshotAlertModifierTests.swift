/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import SwiftUI
import MGOTest

final class ScreenshotAlertModifierTests: XCTestCase {
	
	func test_alert() throws {
		
		// Given
		let sut = Text("Screenshot Alert").screenshotAlert()
		
		// When
		NotificationCenter.default.post(name: UIApplication.userDidTakeScreenshotNotification, object: nil)
		
		// Then
		takeSnapShots(content: sut)
	}
}
