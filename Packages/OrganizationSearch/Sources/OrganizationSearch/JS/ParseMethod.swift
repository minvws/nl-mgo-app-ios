/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// JavaScript method names exposed by the `OrgSearchApi` namespace.
///
/// Each case's `rawValue` is the exact function name invoked on the JS object,
/// e.g. `jsContext["OrgSearchApi"].invokeMethod(ParseMethod.index.rawValue, ...)`.
public enum ParseMethod: String, Sendable {

	/// Builds a full-text search index from a JSON organization payload.
	/// Corresponds to the JS function `createSearchIndexJson`.
	case index = "createSearchIndexJson"

	/// Executes a search query against the previously built index.
	/// Corresponds to the JS function `search`.
	case search = "search"
}
