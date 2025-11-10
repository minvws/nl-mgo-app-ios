/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import SwiftUI
import MGOTest

final class CallToActionButtonTests: XCTestCase {

	func test_primaryWithLeadingIcon() throws {
		
		// Given
		let sut = CallToActionButton(
			"DigiD",
			icon: Image(systemName: "stethoscope"),
			style: .primaryWithLeadingIcon
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
	
	func test_primaryWithLeadingSpinner() throws {
		
		// Given
		let sut = CallToActionButton(
			"Laden...",
			style: .primaryWithLeadingSpinner
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
	
	func test_primary() throws {
		
		// Given
		let sut = CallToActionButton(
			"Solid",
			style: .solid(rounded: false)
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
	
	func test_primary_rounded() throws {
		
		// Given
		let sut = CallToActionButton(
			"Solid",
			style: .solid(rounded: true)
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
	
	func test_primary_asTitle() throws {
		
		// Given
		let sut = CallToActionButton(
			title: "Solid Title",
			style: .solid(rounded: false)
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
	
	func test_secondary() throws {
		
		// Given
		let sut = CallToActionButton(
			"Tonal",
			style: .tonal(rounded: false)
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
	
	func test_secondary_rounded() throws {
		
		// Given
		let sut = CallToActionButton(
			"Tonal",
			style: .tonal(rounded: true)
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
	
	func test_tertiary() throws {
		
		// Given
		let sut = CallToActionButton(
			"Ghost",
			style: .ghost
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
	
	func test_withIcon() throws {
		
		// Given
		let sut = CallToActionButton(
			"With Icon",
			icon: Image(systemName: "stethoscope"),
			style: .withIcon
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
	
	func test_withSpinner() throws {
		
		// Given
		let sut = CallToActionButton(
			"With Spinner",
			style: .withSpinner
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
	
	func test_solidStyle_equality() {
		
		// Given
		let solidRounded = CallToActionButtonStyle.solid(rounded: true)
		let solid = CallToActionButtonStyle.solid(rounded: false)
		
		// When
		
		// Then
		expect(solidRounded) != solid
		expect(solidRounded) == CallToActionButtonStyle.solid(rounded: true)
	}
	
	func test_tonalStyle_equality() {
		
		// Given
		let tonalRounded = CallToActionButtonStyle.tonal(rounded: true)
		let tonal = CallToActionButtonStyle.tonal(rounded: false)
		
		// When
		
		// Then
		expect(tonalRounded) != tonal
		expect(tonalRounded) == CallToActionButtonStyle.tonal(rounded: true)
	}
}
