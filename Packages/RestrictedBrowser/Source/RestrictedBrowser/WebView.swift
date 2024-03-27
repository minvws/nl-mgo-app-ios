/*
*  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import SwiftUI

public protocol RestricedBrowserDelegate: AnyObject {
	
//	associatedtype Body: View
	
	func openInDefaultBrowser(url: URL)
//	
//	func backButton() -> Body
}

public class RestricedBrowserViewModel: ObservableObject {
	
	@Published var title: LocalizedStringKey?
	
	@Published var url: URL
	
	weak private var delegate: (any RestricedBrowserDelegate)?
	
	/// A list of all the actions this viewModel can handle
	public enum Action {
		case safariButtonPressed
	}
		
	public init(url: URL, title: LocalizedStringKey?, delegate: (any RestricedBrowserDelegate)? = nil) {
		self.url = url
		self.title = title
		self.delegate = delegate
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	public func reduce(_ action: Action) {
		switch action {
			case .safariButtonPressed:
				delegate?.openInDefaultBrowser(url: url)
		}
	}
}

public struct RestricedBrowserView: View {
	
	@StateObject var viewModel: RestricedBrowserViewModel
	
	public var body: some View {
		
		WebView(url: viewModel.url)
		.background(.white)
		.navigationTitle(viewModel.title ?? "")
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
//		.navigationBarItems(leading: viewModel.delegate.backButton())
//		.if(viewModel.state.backButtonVisible) { view in
//			// Show the backbutton
//			view.navigationBarItems(leading: BackButton("general_previous") {
//				viewModel.reduce(.backButtonPressed)
//			})
//		}
		
		.toolbar {
			ToolbarItemGroup(placement: .bottomBar) {
				Spacer()
				Button {
					viewModel.reduce(.safariButtonPressed)
				} label: {
					Image(systemName: "safari")
				}
			}
		}
		
	}
}

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

	let url: URL

	func makeUIView(context: Context) -> WKWebView {

		let webConfiguration = WKWebViewConfiguration()
		let view = WKWebView(frame: .zero, configuration: webConfiguration)
		return view
	}

	func updateUIView(_ webView: WKWebView, context: Context) {

		let request = URLRequest(url: url)
		webView.load(request)
	}
}
