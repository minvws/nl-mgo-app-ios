// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let purpleBodySite = try PurpleBodySite(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - PurpleBodySite
public struct PurpleBodySite: Codable, Hashable, Sendable {
    public let laterality, morphology, value: MgoCodeableConcept?

    public init(laterality: MgoCodeableConcept?, morphology: MgoCodeableConcept?, value: MgoCodeableConcept?) {
        self.laterality = laterality
        self.morphology = morphology
        self.value = value
    }
}

// MARK: PurpleBodySite convenience initializers and mutators

public extension PurpleBodySite {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PurpleBodySite.self, from: data)
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
        laterality: MgoCodeableConcept?? = nil,
        morphology: MgoCodeableConcept?? = nil,
        value: MgoCodeableConcept?? = nil
    ) -> PurpleBodySite {
        return PurpleBodySite(
            laterality: laterality ?? self.laterality,
            morphology: morphology ?? self.morphology,
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
