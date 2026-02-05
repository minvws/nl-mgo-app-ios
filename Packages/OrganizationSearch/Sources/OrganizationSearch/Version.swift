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
	public let version: String
	public let gitRef: String
	public let created: String
	
	public enum CodingKeys: String, CodingKey {
		case version = "version"
		case gitRef = "git_ref"
		case created = "created"
	}
	
	public init(version: String, gitRef: String, created: String) {
		self.version = version
		self.gitRef = gitRef
		self.created = created
	}
	
	/// the errors
	public enum Error: Swift.Error, Sendable {
		
		/// No resource file found
		case noResource
	}
}

// MARK: OrganizationSearchVersion convenience initializers and mutators

public extension Version {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(Version.self, from: data)
	}
	
	init(_ json: String, using encoding: String.Encoding = .utf8) throws {
		guard let data = json.data(using: encoding) else {
			throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
		}
		try self.init(data: data)
	}
	
	init(fromURL url: URL) throws {
		try self.init(data: try Data(contentsOf: url))
	}
	
	func jsonData() throws -> Data {
		return try newJSONEncoder().encode(self)
	}
	
	func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
		return String(data: try self.jsonData(), encoding: encoding)
	}
}
