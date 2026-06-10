// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4ImmPharmaceuticalProductIngredient = try R4ImmPharmaceuticalProductIngredient(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4ImmPharmaceuticalProductIngredient
public struct R4ImmPharmaceuticalProductIngredient: Codable, Hashable, Sendable {
    public let itemCodeableConcept: MgoCodeableConcept?
    public let itemReference: MgoReference?
    public let strength: MgoRatio?

    public init(itemCodeableConcept: MgoCodeableConcept?, itemReference: MgoReference?, strength: MgoRatio?) {
        self.itemCodeableConcept = itemCodeableConcept
        self.itemReference = itemReference
        self.strength = strength
    }
}

// MARK: R4ImmPharmaceuticalProductIngredient convenience initializers and mutators

public extension R4ImmPharmaceuticalProductIngredient {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4ImmPharmaceuticalProductIngredient.self, from: data)
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
        itemCodeableConcept: MgoCodeableConcept?? = nil,
        itemReference: MgoReference?? = nil,
        strength: MgoRatio?? = nil
    ) -> R4ImmPharmaceuticalProductIngredient {
        return R4ImmPharmaceuticalProductIngredient(
            itemCodeableConcept: itemCodeableConcept ?? self.itemCodeableConcept,
            itemReference: itemReference ?? self.itemReference,
            strength: strength ?? self.strength
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
