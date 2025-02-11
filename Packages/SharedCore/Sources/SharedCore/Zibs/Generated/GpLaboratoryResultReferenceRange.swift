// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let gpLaboratoryResultReferenceRange = try GpLaboratoryResultReferenceRange(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - GpLaboratoryResultReferenceRange
public struct GpLaboratoryResultReferenceRange: Codable, Hashable, Sendable {
    public let age: MgoRange?
    public let appliesTo: [MgoCodeableConcept]?
    public let high, low: MgoDuration?
    public let type: MgoCodeableConcept?

    public init(age: MgoRange?, appliesTo: [MgoCodeableConcept]?, high: MgoDuration?, low: MgoDuration?, type: MgoCodeableConcept?) {
        self.age = age
        self.appliesTo = appliesTo
        self.high = high
        self.low = low
        self.type = type
    }
}

// MARK: GpLaboratoryResultReferenceRange convenience initializers and mutators

public extension GpLaboratoryResultReferenceRange {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GpLaboratoryResultReferenceRange.self, from: data)
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
        age: MgoRange?? = nil,
        appliesTo: [MgoCodeableConcept]?? = nil,
        high: MgoDuration?? = nil,
        low: MgoDuration?? = nil,
        type: MgoCodeableConcept?? = nil
    ) -> GpLaboratoryResultReferenceRange {
        return GpLaboratoryResultReferenceRange(
            age: age ?? self.age,
            appliesTo: appliesTo ?? self.appliesTo,
            high: high ?? self.high,
            low: low ?? self.low,
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
