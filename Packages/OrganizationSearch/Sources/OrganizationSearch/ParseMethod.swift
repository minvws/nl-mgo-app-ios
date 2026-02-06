/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// The different parse methods for the Organization Search
public enum ParseMethod: String, Sendable {
	
	/// parse the organizations and create a search index
	case index = "createSearchIndexJson"

	/// Search for an organization
	case search = "search"
}
