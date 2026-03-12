/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import RestrictedBrowser
import WebKit

@MainActor
final class RestrictedBrowserViewModelTests: XCTestCase {
	
	@MainActor func test_reduce() throws {
		
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
	
	func test_didReceive_authenticationMode_serverTrust() throws {
		
		// Given
		let challenge = challenge(authenticationMethod: NSURLAuthenticationMethodServerTrust)
		let urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let url = try XCTUnwrap(URL(string: "https://support.apple.com"))
		let browser = RestrictedBrowser(allowedDomains: ["localhost"], urlOpener: urlOpenerSpy)
		let sut = RestrictedBrowserViewModel(url: url, browser: browser)
		let completionHandler = MockWebViewDidReceiveCompletionHandler()
		
		// When
		sut.webView(
			WKWebView(),
			didReceive: challenge,
			completionHandler: completionHandler.completionHandler
		)
		
		// Then
		expect(completionHandler.disposition) == .performDefaultHandling
		expect(completionHandler.credential) == nil
	}
	
	func test_didReceive_authenticationMode_default_withoutCredentials() throws {
		
		// Given
		let challenge = challenge(authenticationMethod: NSURLAuthenticationMethodDefault)
		let urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let url = try XCTUnwrap(URL(string: "https://support.apple.com"))
		let browser = RestrictedBrowser(allowedDomains: ["localhost"], urlOpener: urlOpenerSpy)
		let sut = RestrictedBrowserViewModel(url: url, browser: browser)
		let completionHandler = MockWebViewDidReceiveCompletionHandler()
		
		// When
		sut.webView(
			WKWebView(),
			didReceive: challenge,
			completionHandler: completionHandler.completionHandler
		)
		
		// Then
		expect(completionHandler.disposition) == .cancelAuthenticationChallenge
		expect(completionHandler.credential) == nil
	}
	
	func test_didReceive_authenticationMode_default() throws {
		
		// Given
		let challenge = challenge(authenticationMethod: NSURLAuthenticationMethodDefault)
		let urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let url = try XCTUnwrap(URL(string: "https://support.apple.com"))
		let browser = RestrictedBrowser(allowedDomains: ["localhost"], urlOpener: urlOpenerSpy)
		let sut = RestrictedBrowserViewModel(
			url: url,
			browser: browser,
			authUsername: "username",
			authPassword: "password"
		)
		let completionHandler = MockWebViewDidReceiveCompletionHandler()
		
		// When
		sut.webView(
			WKWebView(),
			didReceive: challenge,
			completionHandler: completionHandler.completionHandler
		)
		
		// Then
		expect(completionHandler.disposition) == .useCredential
		expect(completionHandler.credential) == URLCredential(user: "username", password: "password", persistence: .forSession)
	}
	
	func test_didReceive_authenticationMode_other() throws {
		
		// Given
		let challenge = challenge(authenticationMethod: NSURLAuthenticationMethodNegotiate)
		let urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let url = try XCTUnwrap(URL(string: "https://support.apple.com"))
		let browser = RestrictedBrowser(allowedDomains: ["localhost"], urlOpener: urlOpenerSpy)
		let sut = RestrictedBrowserViewModel(
			url: url,
			browser: browser,
			authUsername: "username",
			authPassword: "password"
		)
		let completionHandler = MockWebViewDidReceiveCompletionHandler()
		
		// When
		sut.webView(
			WKWebView(),
			didReceive: challenge,
			completionHandler: completionHandler.completionHandler
		)
		
		// Then
		expect(completionHandler.disposition) == .cancelAuthenticationChallenge
		expect(completionHandler.credential) == nil
	}
	
	// MARK: - helper
	
	/// Create a URLAuthenticationChallenge
	/// - Parameter authenticationMethod: the authentication method to use
	/// - Returns: URLAuthenticationChallenge
	private func challenge(authenticationMethod: String) -> URLAuthenticationChallenge {
		
		return URLAuthenticationChallenge(
			protectionSpace: URLProtectionSpace(
				host: "localhost",
				port: 443,
				protocol: "https",
				realm: "Mijn Gezondheidsoverzicht",
				authenticationMethod: authenticationMethod
			),
			proposedCredential: nil,
			previousFailureCount: 0,
			failureResponse: nil,
			error: nil,
			sender: URLAuthenticationChallengeSenderSpy()
		)
	}
}
