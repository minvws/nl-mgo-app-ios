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
	
	func test_primary_asTitle() throws {
		
		// Given
		let sut = CallToActionButton(title: "Primary Title", style: .primary)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
	
	func test_primaryNegative() throws {
		
		// Given
		let sut = CallToActionButton("Primary Negative", style: .primaryNegative)
		
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
	
	func test_secondaryNegative() throws {
		
		// Given
		let sut = CallToActionButton("Secondary Negative", style: .secondaryNegative)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
	
	func test_tertiary() throws {
		
		// Given
		let sut = CallToActionButton("Tertiary", style: .tertiary)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
	
	func test_tertiaryNegative() throws {
		
		// Given
		let sut = CallToActionButton("Tertiary Negative", style: .tertiaryNegative)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
	
	func test_tertairy_withIcon() throws {
		
		// Given
		let sut = CallToActionButton("Tertiary With Icon", icon: Image(systemName: "stethoscope"), style: .tertiaryWithIcon)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
}
