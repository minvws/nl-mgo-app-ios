/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import SwiftUI
import MGOTest

@MainActor
final class ImageContentViewTests: XCTestCase {

	func test_imageContentView() throws {
		
		// Given
		let sut = ImageContentView(
			icon: Image(systemName: "42.circle"),
			heading: "Heading",
			subHeading: "SubHeading",
			configuration: ImageContentView.Configuration(
				titleStyle: .headingExtraLarge,
				subHeadingForegroundColor: Color.pink
			)
		)
		
		// When
		let view = sut.frame(width: 300, height: 600)
		
		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}
	
	func test_imageContentView_customVisual() throws {

		// Given
		let sut = ImageContentView(
			heading: "Heading",
			subHeading: "SubHeading",
			configuration: ImageContentView.Configuration(
				titleStyle: .headingExtraLarge,
				subHeadingForegroundColor: Color.pink
			)
		) {
			Rectangle()
				.fill(Color.blue)
				.frame(width: 100, height: 100)
		}

		// When
		let view = sut.frame(width: 300, height: 600)

		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}

	func test_imageContentView_contentFirst() throws {
		
		// Given
		let sut = ImageContentView(
			icon: Image(systemName: "42.circle"),
			heading: "Heading",
			subHeading: "SubHeading",
			configuration: ImageContentView.Configuration(
				titleStyle: .headingExtraLarge,
				subHeadingForegroundColor: Color.pink,
				order: .contentFirst
			)
		)
		
		// When
		let view = sut.frame(width: 300, height: 600)
		
		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}
	
	func test_onRotate() {
		
		// Given
		let sut = ImageContentView(
			icon: Image(systemName: "42.circle"),
			heading: "Heading",
			subHeading: "SubHeading",
			configuration: ImageContentView.Configuration(
				titleStyle: .headingExtraLarge,
				subHeadingForegroundColor: Color.pink
			)
		)
		
		// When
		sut.handleRotation(UIDeviceOrientation.portrait)
		
		// Then
		expect(sut.showImage) == true
	}
	
	func test_onRotate_disabled() {
		
		// Given
		let sut = ImageContentView(
			icon: Image(systemName: "42.circle"),
			heading: "Heading",
			subHeading: "SubHeading",
			configuration: ImageContentView.Configuration(
				titleStyle: .headingExtraLarge,
				subHeadingForegroundColor: Color.pink,
				hideIconInLandscape: false
			)
		)
		
		// When
		sut.handleRotation(UIDeviceOrientation.portrait)
		
		// Then
		expect(sut.showImage) == true
	}
	
	func test_navigation() {
		
		// Given
		let sut = ImageContentView(
			icon: Image(systemName: "42.circle"),
			heading: "Heading",
			subHeading: "SubHeading",
			configuration: ImageContentView.Configuration(
				titleStyle: .headingExtraLarge,
				subHeadingForegroundColor: Color.pink,
				order: .contentFirst,
				hideIconInLandscape: false,
				headingAsNavigationTitle: true
			)
		)
		
		// When
		let view = sut.frame(width: 300, height: 600)
		
		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}
	
	func test_navigation_inNavigationView() {
		
		// Given
		let sut = ImageContentView(
			icon: Image(systemName: "42.circle"),
			heading: "Heading",
			subHeading: "SubHeading",
			configuration: ImageContentView.Configuration(
				titleStyle: .headingExtraLarge,
				subHeadingForegroundColor: Color.pink,
				order: .contentFirst,
				hideIconInLandscape: false,
				headingAsNavigationTitle: true
			)
		)
		
		// When
		let view = NavigationView { sut }.frame(width: 300, height: 600)
		
		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}
}
