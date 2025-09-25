// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let extensionValueOfStructure0786979168025258 = try ExtensionValueOfStructure0_786979168025258(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ExtensionValueOfStructure0_786979168025258
public struct ExtensionValueOfStructure0_786979168025258: Codable, Hashable, Sendable {
    public let ext: Bool
    public let verificationDate: ExtensionValueOfMgoDateTime?
    public let verified: ExtensionValueOfMgoBoolean?
    public let verifiedWith: ExtensionValueOfMgoCodeableConcept?

    public enum CodingKeys: String, CodingKey {
        case ext = "_ext"
        case verificationDate, verified, verifiedWith
    }

    public init(ext: Bool, verificationDate: ExtensionValueOfMgoDateTime?, verified: ExtensionValueOfMgoBoolean?, verifiedWith: ExtensionValueOfMgoCodeableConcept?) {
        self.ext = ext
        self.verificationDate = verificationDate
        self.verified = verified
        self.verifiedWith = verifiedWith
    }
}

// MARK: ExtensionValueOfStructure0_786979168025258 convenience initializers and mutators

public extension ExtensionValueOfStructure0_786979168025258 {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ExtensionValueOfStructure0_786979168025258.self, from: data)
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
        verificationDate: ExtensionValueOfMgoDateTime?? = nil,
        verified: ExtensionValueOfMgoBoolean?? = nil,
        verifiedWith: ExtensionValueOfMgoCodeableConcept?? = nil
    ) -> ExtensionValueOfStructure0_786979168025258 {
        return ExtensionValueOfStructure0_786979168025258(
            ext: ext ?? self.ext,
            verificationDate: verificationDate ?? self.verificationDate,
            verified: verified ?? self.verified,
            verifiedWith: verifiedWith ?? self.verifiedWith
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
