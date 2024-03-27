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
	
	/// open this url in an external browser
	/// - Parameter url: the url to be opened
	func openInDefaultBrowser(url: URL)
}

public class RestrictedBrowser: DomainDecider {

	private let allowedDomains: [String]
	
	public init(allowedDomains: [String]) {
		self.allowedDomains = allowedDomains
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
		UIApplication.shared.open(url)
	}
}
