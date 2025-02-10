// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let stage = try Stage(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - Stage
public struct Stage: Codable, Hashable, Sendable {
    public let assessment: [MgoReference]?
    public let summary: MgoCodeableConcept?

    public init(assessment: [MgoReference]?, summary: MgoCodeableConcept?) {
        self.assessment = assessment
        self.summary = summary
    }
}

// MARK: Stage convenience initializers and mutators

public extension Stage {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Stage.self, from: data)
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
        assessment: [MgoReference]?? = nil,
        summary: MgoCodeableConcept?? = nil
    ) -> Stage {
        return Stage(
            assessment: assessment ?? self.assessment,
            summary: summary ?? self.summary
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
