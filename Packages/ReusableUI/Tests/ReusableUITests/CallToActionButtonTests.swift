/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import SwiftUI
import MGOTest

final class CallToActionButtonTests: XCTestCase {

	func test_digid() throws {
		
		// Given
		let sut = CallToActionButton("DigiD", icon: Image(systemName: "stethoscope"), style: .loginWithDigiD)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
	
	func test_digid_spinner() throws {
		
		// Given
		let sut = CallToActionButton("Laden...", style: .loginWithDigiDSpinner)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
	
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
	
	func test_primaryCritical() throws {
		
		// Given
		let sut = CallToActionButton("Primary Critical", style: .primaryCritical)
		
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
	
	func test_secondaryCritical() throws {
		
		// Given
		let sut = CallToActionButton("Secondary Critical", style: .secondaryCritical)
		
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
	
	func test_tertiaryCritical() throws {
		
		// Given
		let sut = CallToActionButton("Tertiary Critical", style: .tertiaryCritical)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
	
	func test_withIcon() throws {
		
		// Given
		let sut = CallToActionButton("With Icon", icon: Image(systemName: "stethoscope"), style: .withIcon)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
	
	func test_withSpinner() throws {
		
		// Given
		let sut = CallToActionButton("With Spinner", style: .withSpinner)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image)
	}
}
