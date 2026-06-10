/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import OSVersion
import SwiftUI
import MGOTest

@MainActor
final class CallToActionButtonTests: XCTestCase {
	
	func test_primaryWithLeadingIcon() throws {
		
		// Given
		let sut = CallToActionButton(
			"DigiD",
			icon: Image(systemName: "stethoscope"),
			style: .solidLeadingIcon(rounded: false)
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}
	
	func test_primaryWithLeadingIcon_rounded() throws {
		
		// Given
		let sut = CallToActionButton(
			"DigiD",
			icon: Image(systemName: "stethoscope"),
			style: .solidLeadingIcon(rounded: true)
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}
	
	func test_primaryWithLeadingSpinner() throws {
		
		// Given
		let sut = CallToActionButton(
			"Laden...",
			style: .solidLeadingSpinner(rounded: false)
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}
	
	func test_primaryWithLeadingSpinner_rounded() throws {
		
		// Given
		let sut = CallToActionButton(
			"Laden...",
			style: .solidLeadingSpinner(rounded: true)
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}
	
	func test_primary() throws {
		
		// Given
		let sut = CallToActionButton(
			"Solid",
			style: .solid(rounded: false, narrow: false)
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}
	
	func test_primary_rounded() throws {
		
		// Given
		let sut = CallToActionButton(
			"Solid Rounded",
			style: .solid(rounded: true, narrow: false)
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}
	
	func test_primary_small() throws {
		
		// Given
		let sut = CallToActionButton(
			"Solid Narrow",
			style: .solid(rounded: false, narrow: true)
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}
	
	func test_primary_roundedAndSmall() throws {
		
		// Given
		let sut = CallToActionButton(
			"Solid Narrow and Rounded",
			style: .solid(rounded: true, narrow: true)
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}
	
	func test_primary_asTitle() throws {
		
		// Given
		let sut = CallToActionButton(
			title: "Solid Title",
			style: .solid(rounded: false, narrow: false)
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
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
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
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
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}
	
	func test_secondary_glass() throws {
		
		// Given
		let sut = CallToActionButton(
			"Glass",
			style: .glass(rounded: false)
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}
	
	func test_secondary_glass_rounded() throws {
		
		// Given
		let sut = CallToActionButton(
			"Glass",
			style: .glass(rounded: true)
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
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
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
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
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
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
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}
	
	func test_solidStyle_equality() {
		
		// Given
		let solidRounded = CallToActionButtonStyle.solid(rounded: true, narrow: false)
		let solid = CallToActionButtonStyle.solid(rounded: false, narrow: false)
		
		// When
		
		// Then
		expect(solidRounded) != solid
		expect(solidRounded) == CallToActionButtonStyle.solid(rounded: true, narrow: false)
		expect(solidRounded) != CallToActionButtonStyle.solid(rounded: true, narrow: true)
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
	
	func test_glass_iOS26() throws {
		
		// Given
		let sut = Button("Glass") { /* no-op */ }
			.buttonStyle(
				GlassButtonStyle(
					rounded: false,
					osVersionChecker: OSVersionCheckerTrue()
				)
			)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}
	
	func test_glass_iOS18() throws {
		
		// Given
		let sut = Button("Glass") { /* no-op */ }
			.buttonStyle(
				GlassButtonStyle(
					rounded: false,
					osVersionChecker: OSVersionCheckerFalse()
				)
			)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}
	
	func test_glassStyle_equality() {
		
		// Given
		let glassRounded = CallToActionButtonStyle.glass(rounded: true)
		let glass = CallToActionButtonStyle.glass(rounded: false)
		
		// When
		
		// Then
		expect(glassRounded) != glass
		expect(glassRounded) == CallToActionButtonStyle.glass(rounded: true)
	}
}
