/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// Exposes the generated server URL publicly so callers outside the module
/// can resolve the base URL without depending on internal generated types.
public enum LocalizationServers {

	/// Returns the base URL of the test server.
	/// - Throws: An error if the URL cannot be constructed.
	public static func testUrl() throws -> URL {
		try Servers.Server1.url()
	}

	/// Returns the base URL of the acceptance server.
	/// - Throws: An error if the URL cannot be constructed.
	public static func acceptanceUrl() throws -> URL {
		try Servers.Server2.url()
	}
}
