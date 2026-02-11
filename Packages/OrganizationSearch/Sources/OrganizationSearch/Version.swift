/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/*
 {
 "version": "1138/merge-94dba43",
 "git_ref": "94dba43034b00f04fa4af993594c9092a1945b59",
 "created": "2026-02-04T16:42:54"
 }
*/

public struct Version: Codable, Equatable, Sendable {
	
	/// The version of this package build
	public let version: String
	
	/// The GitHub reference of this package build
	public let gitRef: String
	
	/// When was this package created?
	public let created: String
	
	/// The coding keys for Codable
	public enum CodingKeys: String, CodingKey {
		case version = "version"
		case gitRef = "git_ref"
		case created = "created"
	}
	
	/// Errors
	public enum Error: Swift.Error, Sendable {
		
		/// No resource file found
		case noResource
		
		/// No resource file found
		case invalidResource
	}
}

// MARK: Version convenience initializers and mutators

public extension Version {
	
	/// Create a Version object from Data
	/// - Parameter data: the data
	init(data: Data) throws {
		self = try newJSONDecoder().decode(Version.self, from: data)
	}
	
	/// Create a Version object from a JSON string
	/// - Parameters:
	///   - json: The JSON string
	///   - encoding: any encodig required. Defaults to UTF8
	init(_ json: String, using encoding: String.Encoding = .utf8) throws {
		guard let data = json.data(using: encoding) else {
			throw Error.invalidResource
		}
		try self.init(data: data)
	}
}
