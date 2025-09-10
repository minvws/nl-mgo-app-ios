// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let extensionValueOfMgoPeriod = try ExtensionValueOfMgoPeriod(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ExtensionValueOfMgoPeriod
public struct ExtensionValueOfMgoPeriod: Codable, Hashable, Sendable {
    public let ext: Bool
    public let type: MgoPeriodType
    public let end, start: String?

    public enum CodingKeys: String, CodingKey {
        case ext = "_ext"
        case type = "_type"
        case end, start
    }

    public init(ext: Bool, type: MgoPeriodType, end: String?, start: String?) {
        self.ext = ext
        self.type = type
        self.end = end
        self.start = start
    }
}

// MARK: ExtensionValueOfMgoPeriod convenience initializers and mutators

public extension ExtensionValueOfMgoPeriod {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ExtensionValueOfMgoPeriod.self, from: data)
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
        type: MgoPeriodType? = nil,
        end: String?? = nil,
        start: String?? = nil
    ) -> ExtensionValueOfMgoPeriod {
        return ExtensionValueOfMgoPeriod(
            ext: ext ?? self.ext,
            type: type ?? self.type,
            end: end ?? self.end,
            start: start ?? self.start
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
