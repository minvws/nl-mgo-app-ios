/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public protocol DomainDecider {
	
	/// Is this domain allowed
	/// - Parameter url: the url to inspedt
	/// - Returns: True if the domain of the url is allowed
	func isDomainAllowed(_ url: URL) -> Bool
	
	/// Handle an unallowed domain
	/// - Parameter url: the url that is not allowed
	func handleUnallowedDomain(_ url: URL)
}

public class RestrictedBrowser: DomainDecider {

	private let allowedDomains: [String]
	
	private let title: LocalizedStringKey?
	
	public weak var delegate: (any RestricedBrowserDelegate)?
	
	public init(title: LocalizedStringKey?, allowedDomains: [String], delegate: (any RestricedBrowserDelegate)? = nil) {
		self.title = title
		self.allowedDomains = allowedDomains
		self.delegate = delegate
	}
	
	/// Get the view for the url
	/// - Parameter url: the url to display
	/// - Returns: WebView
	@ViewBuilder public func openUrl(_ url: URL) -> some View {
//
//		if isDomainAllowed(url) {
//			logDebug("Domain \(url.absoluteString) is allowed")
//			let viewController = WebViewController(viewModel: WebViewModel(url: url, title: title, domainDecider: self))
//			navigationController.pushViewController(viewController, animated: true)
//		} else {
//			logDebug("Domain \(url.absoluteString) is NOT allowed")
//			handleUnallowedDomain(url)
//		}
		RestricedBrowserView(viewModel: RestricedBrowserViewModel(url: url, title: self.title, delegate: self.delegate))
	}
	
	/// Is this domain allowed
	/// - Parameter url: the url to inspedt
	/// - Returns: True if the domain of the url is allowed
	public func isDomainAllowed(_ url: URL) -> Bool {
		
		guard let host = url.host, !allowedDomains.isEmpty else {
			return false
		}
		return allowedDomains.contains(host)
	}
	
		/// Handle an unallowed domain
		/// - Parameter url: the url that is not allowed
	public func handleUnallowedDomain(_ url: URL) {
		// Open unallowed domains in the default browser
		UIApplication.shared.open(url)
	}
}
