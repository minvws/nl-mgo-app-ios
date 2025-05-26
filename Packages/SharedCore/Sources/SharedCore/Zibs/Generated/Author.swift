// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let author = try Author(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - Author
public struct Author: Codable, Hashable, Sendable {
    public let ext: Bool
    public let type: MgoReferenceType
    public let display, reference: String?

    public enum CodingKeys: String, CodingKey {
        case ext = "_ext"
        case type = "_type"
        case display, reference
    }

    public init(ext: Bool, type: MgoReferenceType, display: String?, reference: String?) {
        self.ext = ext
        self.type = type
        self.display = display
        self.reference = reference
    }
}

// MARK: Author convenience initializers and mutators

public extension Author {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Author.self, from: data)
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
        type: MgoReferenceType? = nil,
        display: String?? = nil,
        reference: String?? = nil
    ) -> Author {
        return Author(
            ext: ext ?? self.ext,
            type: type ?? self.type,
            display: display ?? self.display,
            reference: reference ?? self.reference
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
