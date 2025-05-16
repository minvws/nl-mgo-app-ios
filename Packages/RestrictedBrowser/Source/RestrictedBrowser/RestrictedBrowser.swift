/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public class RestrictedBrowser: DomainDecider {
	
	/// Helper to open urls
	private var urlOpener: URLOpenerProtocol
	
	/// Array of allowed domains
	private let allowedDomains: [String]
	
	/// Initializer
	/// - Parameter allowedDomains: the array of allowed domains
	public init(allowedDomains: [String], urlOpener: URLOpenerProtocol = UIApplication.shared) {
		self.allowedDomains = allowedDomains
		self.urlOpener = urlOpener
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
		openInDefaultBrowser(url: url)
	}
	
	/// open this url in an external browser
	/// - Parameter url: the url to be opened
	public func openInDefaultBrowser(url: URL) {
		urlOpener.openUrlIfPossible(url)
	}
}
