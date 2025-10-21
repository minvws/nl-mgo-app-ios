// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nursingIntervention = try NursingIntervention(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NursingIntervention
public struct NursingIntervention: Codable, Hashable, Sendable {
    public let comment: ExtensionValueOfMgoString?
    public let detail: Detail
    public let outcomeCodeableConcept: [MgoCodeableConcept]?
    public let outcomeReference: [MgoReference]?
    public let reference: MgoReference?

    public init(comment: ExtensionValueOfMgoString?, detail: Detail, outcomeCodeableConcept: [MgoCodeableConcept]?, outcomeReference: [MgoReference]?, reference: MgoReference?) {
        self.comment = comment
        self.detail = detail
        self.outcomeCodeableConcept = outcomeCodeableConcept
        self.outcomeReference = outcomeReference
        self.reference = reference
    }
}

// MARK: NursingIntervention convenience initializers and mutators

public extension NursingIntervention {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NursingIntervention.self, from: data)
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
        comment: ExtensionValueOfMgoString?? = nil,
        detail: Detail? = nil,
        outcomeCodeableConcept: [MgoCodeableConcept]?? = nil,
        outcomeReference: [MgoReference]?? = nil,
        reference: MgoReference?? = nil
    ) -> NursingIntervention {
        return NursingIntervention(
            comment: comment ?? self.comment,
            detail: detail ?? self.detail,
            outcomeCodeableConcept: outcomeCodeableConcept ?? self.outcomeCodeableConcept,
            outcomeReference: outcomeReference ?? self.outcomeReference,
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
