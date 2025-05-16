/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI
@preconcurrency import WebKit

// MARK: - WKNavigationDelegate

extension RestrictedBrowserViewModel: WKNavigationDelegate {
	
	/// WKNavigationDelegate method to decice if a navigtion is allowed or canceled.
	/// - Parameters:
	///   - webView: The web view invoking the delegate method.
	///   - navigationAction: Descriptive information about the action triggering the navigation request.
	///   - decisionHandler: The decision handler to call to allow or cancel the navigation.
	///    The argument is one of the constants of the enumerated type WKNavigationActionPolicy.
	public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		
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
	
	public func webView(
		_ webView: WKWebView,
		didReceive challenge: URLAuthenticationChallenge,
		completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
			
		// See https://stackoverflow.com/a/51667317/443270
			
		guard let hostname = webView.url?.host else {
			return
		}
		
		let authenticationMethod = challenge.protectionSpace.authenticationMethod
		if authenticationMethod == NSURLAuthenticationMethodDefault || authenticationMethod == NSURLAuthenticationMethodHTTPBasic || authenticationMethod == NSURLAuthenticationMethodHTTPDigest {
			let av = alertController(hostname: hostname, completionHandler: completionHandler)
			UIApplication.shared.firstKeyWindow?.rootViewController?.present(av, animated: true)
			
		} else if authenticationMethod == NSURLAuthenticationMethodServerTrust {
			completionHandler(.performDefaultHandling, nil)
		} else {
			completionHandler(.cancelAuthenticationChallenge, nil)
		}
	}
	
	public func alertController(hostname: String, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> UIAlertController {
		
		let alertController = UIAlertController(title: String(localized: "login \(hostname)", table: "Browser", bundle: .module), message: nil, preferredStyle: .alert)
		alertController.addTextField(configurationHandler: { textField in
			textField.placeholder = String(localized: "username", table: "Browser", bundle: .module)
		})
		alertController.addTextField(configurationHandler: { textField in
			textField.placeholder = String(localized: "password", table: "Browser", bundle: .module)
			textField.isSecureTextEntry = true
		})
		
		alertController.addAction(UIAlertAction(title: String(localized: "ok", table: "Browser", bundle: .module), style: .default, handler: { action in
			guard let userId = alertController.textFields?.first?.text else {
				return
			}
			guard let password = alertController.textFields?.last?.text else {
				return
			}
			let credential = URLCredential(user: userId, password: password, persistence: .forSession)
			completionHandler(.useCredential, credential)
		}))
		alertController.addAction(UIAlertAction(title: String(localized: "cancel", table: "Browser", bundle: .module), style: .cancel, handler: { _ in
			completionHandler(.cancelAuthenticationChallenge, nil)
		}))
		return alertController
	}
}
