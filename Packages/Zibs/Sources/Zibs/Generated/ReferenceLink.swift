// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let referenceLink = try ReferenceLink(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ReferenceLink
public struct ReferenceLink: Codable, Hashable, Sendable {
    public let label, reference: String
    public let type: ReferenceLinkType

    public init(label: String, reference: String, type: ReferenceLinkType) {
        self.label = label
        self.reference = reference
        self.type = type
    }
}

// MARK: ReferenceLink convenience initializers and mutators

public extension ReferenceLink {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ReferenceLink.self, from: data)
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
        label: String? = nil,
        reference: String? = nil,
        type: ReferenceLinkType? = nil
    ) -> ReferenceLink {
        return ReferenceLink(
            label: label ?? self.label,
            reference: reference ?? self.reference,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
