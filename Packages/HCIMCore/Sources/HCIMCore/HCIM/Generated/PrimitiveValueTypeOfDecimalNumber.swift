// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let primitiveValueTypeOfDecimalNumber = try PrimitiveValueTypeOfDecimalNumber(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - PrimitiveValueTypeOfDecimalNumber
public struct PrimitiveValueTypeOfDecimalNumber: Codable, Hashable, Sendable {
    public let type: MgoDecimalType
    public let value: Double

    public enum CodingKeys: String, CodingKey {
        case type = "_type"
        case value
    }

    public init(type: MgoDecimalType, value: Double) {
        self.type = type
        self.value = value
    }
}

// MARK: PrimitiveValueTypeOfDecimalNumber convenience initializers and mutators

public extension PrimitiveValueTypeOfDecimalNumber {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PrimitiveValueTypeOfDecimalNumber.self, from: data)
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
        type: MgoDecimalType? = nil,
        value: Double? = nil
    ) -> PrimitiveValueTypeOfDecimalNumber {
        return PrimitiveValueTypeOfDecimalNumber(
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
