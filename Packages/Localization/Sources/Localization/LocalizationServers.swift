/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// Exposes the generated server URL publicly so callers outside the module
/// can resolve the base URL without depending on internal generated types.
public enum LocalizationServers {
	public enum Server {
		/// Returns the base URL of Server 1 as defined in the OpenAPI spec.
		/// - Throws: An error if the URL cannot be constructed.
		public static func testUrl() throws -> URL {
			try Servers.Server1.url()
		}
	}
}
