// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibLaboratoryTestResultObservationReferenceRange = try ZibLaboratoryTestResultObservationReferenceRange(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibLaboratoryTestResultObservationReferenceRange
public struct ZibLaboratoryTestResultObservationReferenceRange: Codable, Hashable, Sendable {
    public let high, low: MgoQuantity?
    public let type: MgoCodeableConcept?

    public init(high: MgoQuantity?, low: MgoQuantity?, type: MgoCodeableConcept?) {
        self.high = high
        self.low = low
        self.type = type
    }
}

// MARK: ZibLaboratoryTestResultObservationReferenceRange convenience initializers and mutators

public extension ZibLaboratoryTestResultObservationReferenceRange {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibLaboratoryTestResultObservationReferenceRange.self, from: data)
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
        high: MgoQuantity?? = nil,
        low: MgoQuantity?? = nil,
        type: MgoCodeableConcept?? = nil
    ) -> ZibLaboratoryTestResultObservationReferenceRange {
        return ZibLaboratoryTestResultObservationReferenceRange(
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
