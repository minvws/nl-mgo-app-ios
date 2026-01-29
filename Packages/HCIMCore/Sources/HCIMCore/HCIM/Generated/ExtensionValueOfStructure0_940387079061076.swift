// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let extensionValueOfStructure0940387079061076 = try ExtensionValueOfStructure0_940387079061076(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ExtensionValueOfStructure0_940387079061076
public struct ExtensionValueOfStructure0_940387079061076: Codable, Hashable, Sendable {
    public let ext: Bool
    public let code: ExtensionValueOfMgoCodeableConcept?
    public let period: ExtensionValueOfMgoPeriod?

    public enum CodingKeys: String, CodingKey {
        case ext = "_ext"
        case code, period
    }

    public init(ext: Bool, code: ExtensionValueOfMgoCodeableConcept?, period: ExtensionValueOfMgoPeriod?) {
        self.ext = ext
        self.code = code
        self.period = period
    }
}

// MARK: ExtensionValueOfStructure0_940387079061076 convenience initializers and mutators

public extension ExtensionValueOfStructure0_940387079061076 {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ExtensionValueOfStructure0_940387079061076.self, from: data)
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
        code: ExtensionValueOfMgoCodeableConcept?? = nil,
        period: ExtensionValueOfMgoPeriod?? = nil
    ) -> ExtensionValueOfStructure0_940387079061076 {
        return ExtensionValueOfStructure0_940387079061076(
            ext: ext ?? self.ext,
            code: code ?? self.code,
            period: period ?? self.period
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
