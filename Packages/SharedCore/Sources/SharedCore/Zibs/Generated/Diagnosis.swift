// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let diagnosis = try Diagnosis(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - Diagnosis
public struct Diagnosis: Codable, Hashable, Sendable {
    public let condition: MgoReference?
    public let rank: Double?
    public let role: MgoCodeableConcept?

    public init(condition: MgoReference?, rank: Double?, role: MgoCodeableConcept?) {
        self.condition = condition
        self.rank = rank
        self.role = role
    }
}

// MARK: Diagnosis convenience initializers and mutators

public extension Diagnosis {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Diagnosis.self, from: data)
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
        condition: MgoReference?? = nil,
        rank: Double?? = nil,
        role: MgoCodeableConcept?? = nil
    ) -> Diagnosis {
        return Diagnosis(
            condition: condition ?? self.condition,
            rank: rank ?? self.rank,
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
