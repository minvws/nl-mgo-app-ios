/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest
import Nimble
@testable import RestrictedBrowser

final class RestricedBrowserViewModelTests: XCTestCase {
	
	func test_reduce() throws {
		
		// Given
		let urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let url = try XCTUnwrap(URL(string: "https://support.apple.com"))
		let browser = RestrictedBrowser(allowedDomains: ["apple.com"], urlOpener: urlOpenerSpy)
		let sut = RestrictedBrowserViewModel(url: url, browser: browser)
		
		// When
		sut.reduce(.safariButtonPressed)
		
		// Then
		expect(urlOpenerSpy.invokedCanOpenURL) == true
		expect(urlOpenerSpy.invokedOpen) == true
	}
}
