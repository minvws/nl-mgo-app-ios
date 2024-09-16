// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let policy = try Policy(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - Policy
public struct Policy: Codable, Hashable, Sendable {
    public let authority, id, uri: String?

    public init(authority: String?, id: String?, uri: String?) {
        self.authority = authority
        self.id = id
        self.uri = uri
    }
}

// MARK: Policy convenience initializers and mutators

public extension Policy {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Policy.self, from: data)
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

    func with(
        authority: String?? = nil,
        id: String?? = nil,
        uri: String?? = nil
    ) -> Policy {
        return Policy(
            authority: authority ?? self.authority,
            id: id ?? self.id,
            uri: uri ?? self.uri
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
