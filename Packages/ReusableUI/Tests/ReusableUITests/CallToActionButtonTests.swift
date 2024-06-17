/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import SwiftUI
import MGOTest

final class CallToActionButtonTests: XCTestCase {

	func test_primary() throws {
		
		// Given
		let sut = CallToActionButton("Primary", style: .primary)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
	
	func test_secondary() throws {
		
		// Given
		let sut = CallToActionButton("Secondary", style: .secondary)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
	
	func test_destructive() throws {
		
		// Given
		let sut = CallToActionButton("Destructive", style: .destructive)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
}
