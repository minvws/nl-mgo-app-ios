/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

// MARK: - Binary
public struct FHIRBinary: Codable, Hashable, Sendable {
	public let contentType: String
	public let content: String
	
	/// Create a binary
	/// - Parameters:
	///   - contentType: the content type
	///   - content: the base64 encoded content
	public init(contentType: String, content: String) {
		self.contentType = contentType
		self.content = content
	}
}

// MARK: Evidence convenience initializers and mutators

public extension FHIRBinary {
	
	/// Create a binary from data
	/// - Parameter data: the data
	init(data: Data) throws {
		self = try newJSONDecoder().decode(FHIRBinary.self, from: data)
	}
}
