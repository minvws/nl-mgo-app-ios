/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import SwiftUI
import MGOTest

final class ConditionalViewModifierTests: XCTestCase {

	func test_conditionalViewModifier_conditionFalse() throws {
		
		// Given
		let text = Text("test_conditionalViewModifier").frame(width: 300, height: 50)
		let condition = false
		
		// When
		let sut = text.when(condition) { view in
			view.border(Color.red)
		}
		
		// Then
		assertSnapshot(of: sut, as: .image)
	}
	
	func test_conditionalViewModifier_conditionTrue() throws {
		
		// Given
		let text = Text("test_conditionalViewModifier").frame(width: 300, height: 50)
		let condition = true
		
		// When
		let sut = text.when(condition) { view in
			view.border(Color.red)
		}
		
		// Then
		assertSnapshot(of: sut, as: .image)
	}
}
