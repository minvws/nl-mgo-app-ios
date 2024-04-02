/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI
import WebKit

// MARK: - WKNavigationDelegate

extension RestricedBrowserViewModel: WKNavigationDelegate {
	
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
			let av = UIAlertController(title: String(localized: "login \(hostname)", table: "Browser", bundle: .module), message: nil, preferredStyle: .alert)
			av.addTextField(configurationHandler: { textField in
				textField.placeholder = String(localized: "username", table: "Browser", bundle: .module)
			})
			av.addTextField(configurationHandler: { textField in
				textField.placeholder = String(localized: "password", table: "Browser", bundle: .module)
				textField.isSecureTextEntry = true
			})
			
			av.addAction(UIAlertAction(title: String(localized: "ok", table: "Browser", bundle: .module), style: .default, handler: { action in
				guard let userId = av.textFields?.first?.text else {
					return
				}
				guard let password = av.textFields?.last?.text else {
					return
				}
				let credential = URLCredential(user: userId, password: password, persistence: .none)
				completionHandler(.useCredential, credential)
			}))
			av.addAction(UIAlertAction(title: String(localized: "cancel", table: "Browser", bundle: .module), style: .cancel, handler: { _ in
				completionHandler(.cancelAuthenticationChallenge, nil)
			}))
			UIApplication.shared.firstKeyWindow?.rootViewController?.present(av, animated: true)
			
		} else if authenticationMethod == NSURLAuthenticationMethodServerTrust {
			completionHandler(.performDefaultHandling, nil)
		} else {
			completionHandler(.cancelAuthenticationChallenge, nil)
		}
	}
}
