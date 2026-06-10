/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import OSVersion
@testable import RestrictedBrowser
import SwiftUI

@MainActor
final class RestrictedBrowserViewTests: XCTestCase {
	
	private var urlOpenerSpy: URLOpenerSpy!
	private var sut: RestrictedBrowserView!
	
	func setupSut(
		osVersionChecker: any OSVersionProtocol = OSVersionCheckerTrue()
	) throws {
		
		urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let url = try XCTUnwrap(URL(string: "https://localhost"))
		let browser = RestrictedBrowser(allowedDomains: ["localhost"], urlOpener: urlOpenerSpy)
		let viewModel = RestrictedBrowserViewModel(
			url: url,
			browser: browser
		)
		sut = RestrictedBrowserView(
			viewModel: viewModel,
			osVersionChecker: osVersionChecker
		)
	}
	
	func test_restrictedBrowserView_dark() throws {
		
		// Given
		try setupSut()
		
		// When
		let content = NavigationView { sut }.frame(width: 300, height: 800)
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.dark)),
			as: .image(perceptualPrecision: 0.95),
			named: "_darkPortrait"
		)
	}
	
	func test_restrictedBrowserView_light() throws {
		
		// Given
		try setupSut()
		
		// When
		let content = NavigationView { sut }.frame(width: 300, height: 800)
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.light)),
			as: .image(perceptualPrecision: 0.95),
			named: "_lightPortrait"
		)
	}
	
	func test_navigationBarButtonStyle_iOS26() throws {
		
		// Given
		let sut = Button("Safari") { /* no-op */ }
			.buttonStyle(NavigationBarButtonStyle(
				osVersionChecker: OSVersionCheckerTrue())
			)
		
		// When
		let view = sut.frame(width: 200, height: 60)
		
		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}
	
	func test_navigationBarButtonStyle_iOS18() throws {
		
		// Given
		let sut = Button("Safari") { /* no-op */ }
			.buttonStyle(NavigationBarButtonStyle(
				osVersionChecker: OSVersionCheckerFalse())
			)
		
		// When
		let view = sut.frame(width: 200, height: 60)
		
		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}
	
	func test_restrictedBrowserView_iOS26_light() throws {
		
		// Given
		try setupSut(osVersionChecker: OSVersionCheckerTrue())
		
		// When
		let content = NavigationView { sut }.frame(width: 300, height: 800)
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.light)),
			as: .image(perceptualPrecision: 0.95),
			named: "_iOS26_lightPortrait"
		)
	}
	
	func test_restrictedBrowserView_iOS18_light() throws {
		
		// Given
		try setupSut(osVersionChecker: OSVersionCheckerFalse())
		
		// When
		let content = NavigationView { sut }.frame(width: 300, height: 800)
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.light)),
			as: .image(perceptualPrecision: 0.95),
			named: "_iOS18_lightPortrait"
		)
	}
}
