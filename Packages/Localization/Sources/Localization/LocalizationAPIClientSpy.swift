/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// Test double for `LocalizationAPIClientProtocol`.
///
/// Records every call made to `fetch(_:eTag:)` and exposes the captured
/// arguments via `invoked*` properties. The return value can be configured
/// per-endpoint through `stubbedFetchResults` or globally via `stubbedFetchResult`.
public final class LocalizationAPIClientSpy: LocalizationAPIClientProtocol, @unchecked Sendable {

	public init() { /* no-op */ }
	public required init(_ url: URL, username: String, password: String) { /* no-op */ }
	public required init(_ url: URL) { /* no-op */ }

	public var invokedFetch = false
	public var invokedFetchCount = 0
	public var invokedFetchParameters: (kind: LocalizationEndpoint, eTag: String?)?
	public var invokedFetchParametersList = [(kind: LocalizationEndpoint, eTag: String?)]()

	/// Per-endpoint result overrides. Takes precedence over `stubbedFetchResult`.
	public var stubbedFetchResults: [LocalizationEndpoint: (statusCode: Int, eTag: String?, data: Data?)] = [:]

	/// Fallback result used when no per-endpoint override is configured.
	public var stubbedFetchResult: (statusCode: Int, eTag: String?, data: Data?) = (200, nil, nil)

	/// If set, `fetch` throws this error instead of returning a result.
	public var stubbedFetchError: Error?

	public func fetch(
		_ kind: LocalizationEndpoint,
		eTag: String?
	) async throws -> (statusCode: Int, eTag: String?, data: Data?) {

		invokedFetch = true
		invokedFetchCount += 1
		invokedFetchParameters = (kind, eTag)
		invokedFetchParametersList.append((kind, eTag))

		if let error = stubbedFetchError { throw error }
		return stubbedFetchResults[kind] ?? stubbedFetchResult
	}
}
