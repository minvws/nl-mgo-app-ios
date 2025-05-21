// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibProductIngredient = try ZibProductIngredient(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibProductIngredient
public struct ZibProductIngredient: Codable, Hashable, Sendable {
    public let amount: MgoRatio?
    public let item: MgoCodeableConcept?

    public init(amount: MgoRatio?, item: MgoCodeableConcept?) {
        self.amount = amount
        self.item = item
    }
}

// MARK: ZibProductIngredient convenience initializers and mutators

public extension ZibProductIngredient {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibProductIngredient.self, from: data)
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
        amount: MgoRatio?? = nil,
        item: MgoCodeableConcept?? = nil
    ) -> ZibProductIngredient {
        return ZibProductIngredient(
            amount: amount ?? self.amount,
            item: item ?? self.item
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
