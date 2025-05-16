/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import RestrictedBrowser
import SwiftUI

final class RestrictedBrowserViewTests: XCTestCase {
	
	private var urlOpenerSpy: URLOpenerSpy!
	private var sut: RestrictedBrowserView!
	
	func setupSut() throws {
		
		urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let url = try XCTUnwrap(URL(string: "https://localhost"))
		let browser = RestrictedBrowser(allowedDomains: ["localhost"], urlOpener: urlOpenerSpy)
		let viewModel = RestrictedBrowserViewModel(url: url, browser: browser)
		sut = RestrictedBrowserView(viewModel: viewModel)
	}
	
	func test_restrictedBrowserView_dark() throws {
	
		// Given
		try setupSut()
		
		// When
		let content = NavigationView { sut }.frame(width: 300, height: 800)
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.dark)),
			as: .image,
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
			as: .image,
			named: "_lightPortrait"
		)
	}
}
