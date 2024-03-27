/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
	
	@StateObject var viewModel: RestricedBrowserViewModel
	
	let url: URL
	
	func makeUIView(context: Context) -> WKWebView {
		
		let webConfiguration = WKWebViewConfiguration()
		let view = WKWebView(frame: .zero, configuration: webConfiguration)
		view.navigationDelegate = context.coordinator
		return view
	}
	
	func updateUIView(_ webView: WKWebView, context: Context) {
		
		let request = URLRequest(url: url)
		webView.load(request)
	}
	
	func makeCoordinator() -> RestricedBrowserViewModel {
		return viewModel
	}
}
