// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let eAfspraakAppointment = try EAfspraakAppointment(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - EAfspraakAppointment
public struct EAfspraakAppointment: Codable, Hashable, Sendable {
    public let description, end: String?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let participant: [Participant]?
    public let profile: EAfspraakAppointmentProfile
    public let referenceID: String
    public let resourceType: String?
    public let specialty: [MgoCodeableConcept]?
    public let start, status: String?

    public enum CodingKeys: String, CodingKey {
        case description, end, fhirVersion, id, participant, profile
        case referenceID = "referenceId"
        case resourceType, specialty, start, status
    }

    public init(description: String?, end: String?, fhirVersion: FhirVersionR3, id: String?, participant: [Participant]?, profile: EAfspraakAppointmentProfile, referenceID: String, resourceType: String?, specialty: [MgoCodeableConcept]?, start: String?, status: String?) {
        self.description = description
        self.end = end
        self.fhirVersion = fhirVersion
        self.id = id
        self.participant = participant
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.specialty = specialty
        self.start = start
        self.status = status
    }
}

// MARK: EAfspraakAppointment convenience initializers and mutators

public extension EAfspraakAppointment {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(EAfspraakAppointment.self, from: data)
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
        description: String?? = nil,
        end: String?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        participant: [Participant]?? = nil,
        profile: EAfspraakAppointmentProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        specialty: [MgoCodeableConcept]?? = nil,
        start: String?? = nil,
        status: String?? = nil
    ) -> EAfspraakAppointment {
        return EAfspraakAppointment(
            description: description ?? self.description,
            end: end ?? self.end,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            participant: participant ?? self.participant,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            specialty: specialty ?? self.specialty,
            start: start ?? self.start,
            status: status ?? self.status
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
