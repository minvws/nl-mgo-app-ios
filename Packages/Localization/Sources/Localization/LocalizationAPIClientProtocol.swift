/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// Abstraction over the generated OpenAPI client for fetching the localization datasets.
///
/// Conforming types must support both authenticated (Basic Auth) and unauthenticated initialization,
/// and expose a single `fetch` method that issues conditional GET requests using ETags.
public protocol LocalizationAPIClientProtocol: Sendable {

	/// Create an Localization Dataset API Client with Basic Auth.
	/// - Parameters:
	///   - url: the url to the server
	///   - username: authentication user name
	///   - password: authentication password
	init(_ url: Foundation.URL, username: String, password: String)

	/// Create an Localization Dataset API Client without authentication.
	/// - Parameter url: the url to the server
	init(_ url: Foundation.URL)

	/// Fetch the given dataset from the remote server.
	/// - Parameters:
	///   - kind: which dataset to fetch
	///   - eTag: The ETag for conditional request
	/// - Returns: tuple of status code, eTag and raw data (nil on 304)
	func fetch(
		_ kind: LocalizationEndpoint,
		eTag: String?
	) async throws -> (statusCode: Int, eTag: String?, data: Data?)
}

/// Errors thrown by `LocalizationAPIClient` during a fetch operation.
public enum LocalizationAPIClientError: Error, Equatable, Sendable {
	/// The server returned an HTTP status code that is not covered by the OpenAPI spec.
	case undocumented(Int)
}
