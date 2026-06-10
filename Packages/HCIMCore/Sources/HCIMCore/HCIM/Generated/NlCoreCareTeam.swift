// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCoreCareTeam = try NlCoreCareTeam(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCoreCareTeam
public struct NlCoreCareTeam: Codable, Hashable, Sendable {
    public let fhirVersion: EAfspraakAppointmentFhirVersion
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let participant: [NlCoreCareTeamParticipant]?
    public let period: MgoPeriod?
    public let profile: NlCoreCareTeamProfile
    public let referenceID, resourceType: String
    public let subject: MgoReference?

    public enum CodingKeys: String, CodingKey {
        case fhirVersion, id, identifier, participant, period, profile
        case referenceID = "referenceId"
        case resourceType, subject
    }

    public init(fhirVersion: EAfspraakAppointmentFhirVersion, id: String?, identifier: [MgoIdentifier]?, participant: [NlCoreCareTeamParticipant]?, period: MgoPeriod?, profile: NlCoreCareTeamProfile, referenceID: String, resourceType: String, subject: MgoReference?) {
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.participant = participant
        self.period = period
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.subject = subject
    }
}

// MARK: NlCoreCareTeam convenience initializers and mutators

public extension NlCoreCareTeam {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCoreCareTeam.self, from: data)
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
        fhirVersion: EAfspraakAppointmentFhirVersion? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        participant: [NlCoreCareTeamParticipant]?? = nil,
        period: MgoPeriod?? = nil,
        profile: NlCoreCareTeamProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        subject: MgoReference?? = nil
    ) -> NlCoreCareTeam {
        return NlCoreCareTeam(
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            participant: participant ?? self.participant,
            period: period ?? self.period,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            subject: subject ?? self.subject
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
