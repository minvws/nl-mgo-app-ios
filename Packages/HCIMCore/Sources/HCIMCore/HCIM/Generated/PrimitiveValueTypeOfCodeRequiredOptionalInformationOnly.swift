// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let primitiveValueTypeOfCodeRequiredOptionalInformationOnly = try PrimitiveValueTypeOfCodeRequiredOptionalInformationOnly(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - PrimitiveValueTypeOfCodeRequiredOptionalInformationOnly
public struct PrimitiveValueTypeOfCodeRequiredOptionalInformationOnly: Codable, Hashable, Sendable {
    public let type: MgoCodeType
    public let value: MgoCodeOfRequiredOptionalInformationOnlyValue

    public enum CodingKeys: String, CodingKey {
        case type = "_type"
        case value
    }

    public init(type: MgoCodeType, value: MgoCodeOfRequiredOptionalInformationOnlyValue) {
        self.type = type
        self.value = value
    }
}

// MARK: PrimitiveValueTypeOfCodeRequiredOptionalInformationOnly convenience initializers and mutators

public extension PrimitiveValueTypeOfCodeRequiredOptionalInformationOnly {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PrimitiveValueTypeOfCodeRequiredOptionalInformationOnly.self, from: data)
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
        type: MgoCodeType? = nil,
        value: MgoCodeOfRequiredOptionalInformationOnlyValue? = nil
    ) -> PrimitiveValueTypeOfCodeRequiredOptionalInformationOnly {
        return PrimitiveValueTypeOfCodeRequiredOptionalInformationOnly(
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
