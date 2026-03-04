/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

// MARK: - DataService

/// A set of endpoints for a single data service offered by a healthcare organization.
public struct DataService: Codable, Hashable, Sendable {
	
	/// The URL of the authorization endpoint used to initiate the OAuth flow.
	public let authEndpoint: String

	/// The URL of the FHIR resource endpoint from which health data is fetched.
	public let resourceEndpoint: String

	/// The URL of the token endpoint used to exchange an authorization code for an access token.
	public let tokenEndpoint: String
	
	/// Creates a new `DataService`.
	/// - Parameters:
	///   - authEndpoint: The authorization endpoint URL.
	///   - resourceEndpoint: The FHIR resource endpoint URL.
	///   - tokenEndpoint: The token endpoint URL.
	public init(authEndpoint: String, resourceEndpoint: String, tokenEndpoint: String) {
		self.authEndpoint = authEndpoint
		self.resourceEndpoint = resourceEndpoint
		self.tokenEndpoint = tokenEndpoint
	}
}
