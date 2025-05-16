/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public class RestrictedBrowserViewModel: NSObject, ObservableObject {
	
	/// The initial url to display
	@Published var url: URL
	
	/// The url that is currently being displayed
	var currentUrl: URL
	
	/// The restricted browser
	weak var browser: RestrictedBrowser?
	
	/// A list of all the actions this viewModel can handle
	public enum Action {
		case safariButtonPressed
	}
	
	/// Initializer
	/// - Parameters:
	///   - url: the url to display
	///   - browser: the browser to decide where to display
	public init(url: URL, browser: RestrictedBrowser? = nil) {
		self.url = url
		self.currentUrl = url
		self.browser = browser
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	public func reduce(_ action: Action) {
		switch action {
			case .safariButtonPressed:
				browser?.openInDefaultBrowser(url: currentUrl)
		}
	}
}
