/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public protocol DomainDecider {
	
	/// Is this domain allowed
	/// - Parameter url: the url to inspedt
	/// - Returns: True if the domain of the url is allowed
	@MainActor func isDomainAllowed(_ url: URL) -> Bool
	
	/// Handle an unallowed domain
	/// - Parameter url: the url that is not allowed
	@MainActor func handleUnallowedDomain(_ url: URL)
	
	/// open this url in an external browser
	/// - Parameter url: the url to be opened
	@MainActor func openInDefaultBrowser(url: URL)
}
