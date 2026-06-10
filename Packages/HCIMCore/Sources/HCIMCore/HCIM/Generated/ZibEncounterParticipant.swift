// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibEncounterParticipant = try ZibEncounterParticipant(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibEncounterParticipant
public struct ZibEncounterParticipant: Codable, Hashable, Sendable {
    public let individual: MgoReference?
    public let type: TentacledType

    public init(individual: MgoReference?, type: TentacledType) {
        self.individual = individual
        self.type = type
    }
}

// MARK: ZibEncounterParticipant convenience initializers and mutators

public extension ZibEncounterParticipant {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibEncounterParticipant.self, from: data)
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
        individual: MgoReference?? = nil,
        type: TentacledType? = nil
    ) -> ZibEncounterParticipant {
        return ZibEncounterParticipant(
            individual: individual ?? self.individual,
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
