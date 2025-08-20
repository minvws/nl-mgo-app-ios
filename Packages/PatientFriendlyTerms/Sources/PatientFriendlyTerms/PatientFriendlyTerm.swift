/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

//import Foundation
//
//// MARK: - PatientFriendlyTerm
//
//public struct PatientFriendlyTerm: Codable, Equatable, Sendable {
//	public let description: String
//	public let synonym: String?
//	public let name: String
//	
//	public init(description: String, synonym: String?, name: String) {
//		self.description = description
//		self.synonym = synonym
//		self.name = name
//	}
//}
//
//// MARK: PatientFriendlyTerm convenience initializers and mutators
//
//public extension PatientFriendlyTerm {
//	init(data: Data) throws {
//		self = try JSONDecoder().decode(PatientFriendlyTerm.self, from: data)
//	}
//	
//	init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//		guard let data = json.data(using: encoding) else {
//			throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//		}
//		try self.init(data: data)
//	}
//	
//	init(fromURL url: URL) throws {
//		try self.init(data: try Data(contentsOf: url))
//	}
//	
//	func with(
//		description: String? = nil,
//		synonym: String?? = nil,
//		name: String? = nil
//	) -> PatientFriendlyTerm {
//		return PatientFriendlyTerm(
//			description: description ?? self.description,
//			synonym: synonym ?? self.synonym,
//			name: name ?? self.name
//		)
//	}
//	
//	func jsonData() throws -> Data {
//		return try JSONEncoder().encode(self)
//	}
//	
//	func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//		return String(data: try self.jsonData(), encoding: encoding)
//	}
//}
