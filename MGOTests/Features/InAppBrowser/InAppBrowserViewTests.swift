/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOUI
@testable import MGO
import RestrictedBrowser

final class InAppBrowserViewTests: XCTestCase {
	
	private var sut: InAppBrowserView!
	
	func setupSut() throws {
		
		let coordinatorSpy = AppCoordinatorSpy()
		let urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let url = try XCTUnwrap(URL(string: "http://localhost"))
		let browser = RestrictedBrowser(allowedDomains: ["localhost"], urlOpener: urlOpenerSpy)
		let viewModel = InAppBrowserViewModel(url: url, browser: browser, title: "InAppBrowserView", coordinator: coordinatorSpy)
		sut = InAppBrowserView(viewModel: viewModel)
	}
	
	func test_inAppBrowserView() throws {
		
		// Given
		try setupSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
