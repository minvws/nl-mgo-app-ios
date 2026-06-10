// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mgoCodeOfString = try MgoCodeOfString(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - MgoCodeOfString
public struct MgoCodeOfString: Codable, Hashable, Sendable {
    public let type: MgoCodeOfStringType
    public let value: String

    public enum CodingKeys: String, CodingKey {
        case type = "_type"
        case value
    }

    public init(type: MgoCodeOfStringType, value: String) {
        self.type = type
        self.value = value
    }
}

// MARK: MgoCodeOfString convenience initializers and mutators

public extension MgoCodeOfString {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MgoCodeOfString.self, from: data)
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
        type: MgoCodeOfStringType? = nil,
        value: String? = nil
    ) -> MgoCodeOfString {
        return MgoCodeOfString(
            type: type ?? self.type,
            value: value ?? self.value
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
