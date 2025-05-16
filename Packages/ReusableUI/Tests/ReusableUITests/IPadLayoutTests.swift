/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import SwiftUI
import MGOTest

final class IPadLayoutTests: XCTestCase {

	func test_layout() throws {
		
		// Given
		let sut = Text("A test for layout").background(.red).layoutForIPad(force: false)
			
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShotsForiPad(content: content)
	}
	
	func test_layout_forIpad() throws {
		
		// Given
		let sut = Text("A test for layout").background(.red).layoutForIPad(force: true)
			
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShotsForiPad(content: content)
	}
}
