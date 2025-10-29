// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let target = try Target(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - Target
public struct Target: Codable, Hashable, Sendable {
    public let detailCodeableConcept: MgoCodeableConcept?
    public let detailQuantity: MgoQuantity?
    public let detailRange: MgoRange?
    public let measure: MgoCodeableConcept?

    public init(detailCodeableConcept: MgoCodeableConcept?, detailQuantity: MgoQuantity?, detailRange: MgoRange?, measure: MgoCodeableConcept?) {
        self.detailCodeableConcept = detailCodeableConcept
        self.detailQuantity = detailQuantity
        self.detailRange = detailRange
        self.measure = measure
    }
}

// MARK: Target convenience initializers and mutators

public extension Target {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Target.self, from: data)
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
        detailCodeableConcept: MgoCodeableConcept?? = nil,
        detailQuantity: MgoQuantity?? = nil,
        detailRange: MgoRange?? = nil,
        measure: MgoCodeableConcept?? = nil
    ) -> Target {
        return Target(
            detailCodeableConcept: detailCodeableConcept ?? self.detailCodeableConcept,
            detailQuantity: detailQuantity ?? self.detailQuantity,
            detailRange: detailRange ?? self.detailRange,
            measure: measure ?? self.measure
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
