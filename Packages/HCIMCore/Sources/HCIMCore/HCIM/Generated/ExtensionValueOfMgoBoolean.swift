// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let extensionValueOfMgoBoolean = try ExtensionValueOfMgoBoolean(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ExtensionValueOfMgoBoolean
public struct ExtensionValueOfMgoBoolean: Codable, Hashable, Sendable {
    public let ext: Bool
    public let type: ExtensionValueOfMgoBooleanType
    public let value: Bool

    public enum CodingKeys: String, CodingKey {
        case ext = "_ext"
        case type = "_type"
        case value
    }

    public init(ext: Bool, type: ExtensionValueOfMgoBooleanType, value: Bool) {
        self.ext = ext
        self.type = type
        self.value = value
    }
}

// MARK: ExtensionValueOfMgoBoolean convenience initializers and mutators

public extension ExtensionValueOfMgoBoolean {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ExtensionValueOfMgoBoolean.self, from: data)
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
        type: ExtensionValueOfMgoBooleanType? = nil,
        value: Bool? = nil
    ) -> ExtensionValueOfMgoBoolean {
        return ExtensionValueOfMgoBoolean(
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
