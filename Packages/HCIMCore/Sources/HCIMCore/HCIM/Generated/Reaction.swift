// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let reaction = try Reaction(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - Reaction
public struct Reaction: Codable, Hashable, Sendable {
    public let description: MgoString?
    public let exposureRoute: MgoCodeableConcept?
    public let manifestation: [MgoCodeableConcept]?
    public let onset: MgoDateTime?
    public let severity: Severity
    public let substance: MgoCodeableConcept?

    public init(description: MgoString?, exposureRoute: MgoCodeableConcept?, manifestation: [MgoCodeableConcept]?, onset: MgoDateTime?, severity: Severity, substance: MgoCodeableConcept?) {
        self.description = description
        self.exposureRoute = exposureRoute
        self.manifestation = manifestation
        self.onset = onset
        self.severity = severity
        self.substance = substance
    }
}

// MARK: Reaction convenience initializers and mutators

public extension Reaction {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Reaction.self, from: data)
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
        description: MgoString?? = nil,
        exposureRoute: MgoCodeableConcept?? = nil,
        manifestation: [MgoCodeableConcept]?? = nil,
        onset: MgoDateTime?? = nil,
        severity: Severity? = nil,
        substance: MgoCodeableConcept?? = nil
    ) -> Reaction {
        return Reaction(
            description: description ?? self.description,
            exposureRoute: exposureRoute ?? self.exposureRoute,
            manifestation: manifestation ?? self.manifestation,
            onset: onset ?? self.onset,
            severity: severity ?? self.severity,
            substance: substance ?? self.substance
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
