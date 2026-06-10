// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCoreContactPersonRelationship = try R4NlCoreContactPersonRelationship(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCoreContactPersonRelationship
public struct R4NlCoreContactPersonRelationship: Codable, Hashable, Sendable {
    public let relationship, role: [MgoCodeableConcept]?

    public init(relationship: [MgoCodeableConcept]?, role: [MgoCodeableConcept]?) {
        self.relationship = relationship
        self.role = role
    }
}

// MARK: R4NlCoreContactPersonRelationship convenience initializers and mutators

public extension R4NlCoreContactPersonRelationship {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCoreContactPersonRelationship.self, from: data)
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
        relationship: [MgoCodeableConcept]?? = nil,
        role: [MgoCodeableConcept]?? = nil
    ) -> R4NlCoreContactPersonRelationship {
        return R4NlCoreContactPersonRelationship(
            relationship: relationship ?? self.relationship,
            role: role ?? self.role
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
