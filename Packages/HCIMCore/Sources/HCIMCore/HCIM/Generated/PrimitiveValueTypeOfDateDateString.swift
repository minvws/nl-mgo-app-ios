// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let primitiveValueTypeOfDateDateString = try PrimitiveValueTypeOfDateDateString(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - PrimitiveValueTypeOfDateDateString
public struct PrimitiveValueTypeOfDateDateString: Codable, Hashable, Sendable {
    public let type: MgoDateType
    public let value: String

    public enum CodingKeys: String, CodingKey {
        case type = "_type"
        case value
    }

    public init(type: MgoDateType, value: String) {
        self.type = type
        self.value = value
    }
}

// MARK: PrimitiveValueTypeOfDateDateString convenience initializers and mutators

public extension PrimitiveValueTypeOfDateDateString {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PrimitiveValueTypeOfDateDateString.self, from: data)
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
        type: MgoDateType? = nil,
        value: String? = nil
    ) -> PrimitiveValueTypeOfDateDateString {
        return PrimitiveValueTypeOfDateDateString(
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
