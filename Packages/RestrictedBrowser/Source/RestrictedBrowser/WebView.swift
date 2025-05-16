/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
	
	/// The viewModel
	@StateObject var viewModel: RestrictedBrowserViewModel
	
	/// The url to display
	let url: URL
	
	/// Required UIViewRepresentable method
	/// - Parameter context: the context ( UIViewRepresentableContext)
	/// - Returns: the web view
	func makeUIView(context: Context) -> WKWebView {
		
		let webConfiguration = WKWebViewConfiguration()
		let view = WKWebView(frame: .zero, configuration: webConfiguration)
		view.navigationDelegate = context.coordinator
		return view
	}
	
	/// Required UIViewRepresentable method
	/// - Parameters:
	///   - webView: the webview to update
	///   - context: the context ( UIViewRepresentableContext)
	func updateUIView(_ webView: WKWebView, context: Context) {
		
		let request = URLRequest(url: url)
		webView.load(request)
	}
	
	/// UIViewRepresentable method that adds the viewModel to the context
	/// - Returns: view model as the WKNavigationDelegate
	func makeCoordinator() -> RestrictedBrowserViewModel {
		return viewModel
	}
}
