/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI
@preconcurrency import WebKit

// MARK: - WKNavigationDelegate

extension RestrictedBrowserViewModel: WKNavigationDelegate {
	
	/// WKNavigationDelegate method to decide if a navigation is allowed or canceled.
	/// - Parameters:
	///   - webView: The web view invoking the delegate method.
	///   - navigationAction: Descriptive information about the action triggering the navigation request.
	///   - decisionHandler: The decision handler to call to allow or cancel the navigation.
	///    The argument is one of the constants of the enumerated type WKNavigationActionPolicy.
	public func webView(
		_ webView: WKWebView,
		decidePolicyFor navigationAction: WKNavigationAction,
		decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
	) {
		
		if let url = navigationAction.request.url,
		   let browser = browser {
			self.currentUrl = url
			if browser.isDomainAllowed(url) {
				decisionHandler(.allow)
			} else {
				browser.handleUnallowedDomain(url)
				decisionHandler(.cancel)
			}
			return
		}
		decisionHandler(.cancel)
	}
	
	/// WKNavigationDelegate method to handle authentication
	/// - Parameters:
	///   - webView: The web view invoking the delegate method.
	///   - challenge: The authentication challenge.
	///   - completionHandler: The completion handler you must invoke to respond to the challenge.
	public func webView(
		_ webView: WKWebView,
		didReceive challenge: URLAuthenticationChallenge,
		completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
	) {
	
		switch challenge.protectionSpace.authenticationMethod {
		
			case NSURLAuthenticationMethodDefault, NSURLAuthenticationMethodHTTPBasic, NSURLAuthenticationMethodHTTPDigest:
				guard let authUsername, let authPassword else {
					completionHandler(.cancelAuthenticationChallenge, nil)
					return
				}
				let credential = URLCredential(
					user: authUsername,
					password: authPassword,
					persistence: .forSession
				)
				completionHandler(.useCredential, credential)
				
			case NSURLAuthenticationMethodServerTrust:
				completionHandler(.performDefaultHandling, nil)
			default:
				completionHandler(.cancelAuthenticationChallenge, nil)
		}
	}
}
