/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import RestrictedBrowser
import WebKit

final class RestrictedBrowserViewModelTests: XCTestCase {
	
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
		expect(urlOpenerSpy.invokedOpen).toEventually(beTrue())
	}
	
	func test_alertController() throws {
		
		// Given
		let urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let url = try XCTUnwrap(URL(string: "https://localhost"))
		let browser = RestrictedBrowser(allowedDomains: ["localhost"], urlOpener: urlOpenerSpy)
		let sut = RestrictedBrowserViewModel(url: url, browser: browser)
		
		// When
		let alertController = sut.alertController(hostname: "localhost") { _, _ in }
		
		// Then
		expect(alertController.title) == "Log in op localhost"
	}
	
	func test_policy_allow() throws {
		
		// Given
		let urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let url = try XCTUnwrap(URL(string: "https://localhost"))
		let browser = RestrictedBrowser(allowedDomains: ["localhost"], urlOpener: urlOpenerSpy)
		let sut = RestrictedBrowserViewModel(url: url, browser: browser)
		let testAction = MockNavigationAction(url: url)
		
		// When
		sut.webView(WKWebView(), decidePolicyFor: testAction, decisionHandler: testAction.decisionHandler)
		
		// Then
		expect(testAction.receivedPolicy) == .allow
	}
	
	func test_policy_cancel() throws {
		
		// Given
		let urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let url = try XCTUnwrap(URL(string: "https://support.apple.com"))
		let browser = RestrictedBrowser(allowedDomains: ["localhost"], urlOpener: urlOpenerSpy)
		let sut = RestrictedBrowserViewModel(url: url, browser: browser)
		let testAction = MockNavigationAction(url: url)
		
		// When
		sut.webView(WKWebView(), decidePolicyFor: testAction, decisionHandler: testAction.decisionHandler)
		
		// Then
		expect(testAction.receivedPolicy) == .cancel
	}
}
