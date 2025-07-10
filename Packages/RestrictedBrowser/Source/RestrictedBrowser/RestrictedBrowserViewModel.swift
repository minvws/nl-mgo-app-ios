/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public class RestrictedBrowserViewModel: NSObject, ObservableObject {
	
	/// The initial url to display
	@Published var url: URL
	
	/// The basic auth user name
	internal var authUsername: String?
	
	/// The basic auth password
	internal var authPassword: String?
	
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
	///   - authUsername: the basic auth username (if needed)
	///   - authPassword: the basic auth password (if needed)
	public init(
		url: URL,
		browser: RestrictedBrowser? = nil,
		authUsername: String? = nil,
		authPassword: String? = nil
	) {
		self.url = url
		self.currentUrl = url
		self.browser = browser
		self.authUsername = authUsername
		self.authPassword = authPassword
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
