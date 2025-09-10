// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let extensionValueOfMgoDateTime = try ExtensionValueOfMgoDateTime(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ExtensionValueOfMgoDateTime
public struct ExtensionValueOfMgoDateTime: Codable, Hashable, Sendable {
    public let ext: Bool
    public let type: MgoDateTimeType
    public let value: String

    public enum CodingKeys: String, CodingKey {
        case ext = "_ext"
        case type = "_type"
        case value
    }

    public init(ext: Bool, type: MgoDateTimeType, value: String) {
        self.ext = ext
        self.type = type
        self.value = value
    }
}

// MARK: ExtensionValueOfMgoDateTime convenience initializers and mutators

public extension ExtensionValueOfMgoDateTime {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ExtensionValueOfMgoDateTime.self, from: data)
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
        ext: Bool? = nil,
        type: MgoDateTimeType? = nil,
        value: String? = nil
    ) -> ExtensionValueOfMgoDateTime {
        return ExtensionValueOfMgoDateTime(
            ext: ext ?? self.ext,
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
