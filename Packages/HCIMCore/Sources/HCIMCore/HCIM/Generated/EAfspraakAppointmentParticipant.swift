// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let eAfspraakAppointmentParticipant = try EAfspraakAppointmentParticipant(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - EAfspraakAppointmentParticipant
public struct EAfspraakAppointmentParticipant: Codable, Hashable, Sendable {
    public let actor: MgoReference?
    public let participantRequired: MgoCodeOfRequiredOptionalInformationOnly?
    public let status: MgoCodeOfAcceptedDeclinedTentativeNeedsAction?
    public let type: TentacledType

    public enum CodingKeys: String, CodingKey {
        case actor
        case participantRequired = "required"
        case status, type
    }

    public init(actor: MgoReference?, participantRequired: MgoCodeOfRequiredOptionalInformationOnly?, status: MgoCodeOfAcceptedDeclinedTentativeNeedsAction?, type: TentacledType) {
        self.actor = actor
        self.participantRequired = participantRequired
        self.status = status
        self.type = type
    }
}

// MARK: EAfspraakAppointmentParticipant convenience initializers and mutators

public extension EAfspraakAppointmentParticipant {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(EAfspraakAppointmentParticipant.self, from: data)
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
        actor: MgoReference?? = nil,
        participantRequired: MgoCodeOfRequiredOptionalInformationOnly?? = nil,
        status: MgoCodeOfAcceptedDeclinedTentativeNeedsAction?? = nil,
        type: TentacledType? = nil
    ) -> EAfspraakAppointmentParticipant {
        return EAfspraakAppointmentParticipant(
            actor: actor ?? self.actor,
            participantRequired: participantRequired ?? self.participantRequired,
            status: status ?? self.status,
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
