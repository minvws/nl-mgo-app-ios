/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

// MARK: - DataService
public struct DataService: Codable, Hashable, Sendable {
	
	public let authEndpoint, resourceEndpoint, tokenEndpoint: String
	
	public init(authEndpoint: String, resourceEndpoint: String, tokenEndpoint: String) {
		self.authEndpoint = authEndpoint
		self.resourceEndpoint = resourceEndpoint
		self.tokenEndpoint = tokenEndpoint
	}
}
