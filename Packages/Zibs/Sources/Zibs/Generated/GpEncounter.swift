// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let gpEncounter = try GpEncounter(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - GpEncounter
public struct GpEncounter: Codable, Hashable, Sendable {
    public let gpEncounterClass: MgoCoding?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let participant: [EncounterParticipant]?
    public let period: MgoPeriod?
    public let profile: GpEncounterProfile
    public let reason: [MgoCodeableConcept]?
    public let referenceID: String
    public let resourceType: String?
    public let serviceProvider: MgoReference?

    public enum CodingKeys: String, CodingKey {
        case gpEncounterClass = "class"
        case fhirVersion, id, participant, period, profile, reason
        case referenceID = "referenceId"
        case resourceType, serviceProvider
    }

    public init(gpEncounterClass: MgoCoding?, fhirVersion: FhirVersionR3, id: String?, participant: [EncounterParticipant]?, period: MgoPeriod?, profile: GpEncounterProfile, reason: [MgoCodeableConcept]?, referenceID: String, resourceType: String?, serviceProvider: MgoReference?) {
        self.gpEncounterClass = gpEncounterClass
        self.fhirVersion = fhirVersion
        self.id = id
        self.participant = participant
        self.period = period
        self.profile = profile
        self.reason = reason
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.serviceProvider = serviceProvider
    }
}

// MARK: GpEncounter convenience initializers and mutators

public extension GpEncounter {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GpEncounter.self, from: data)
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
        gpEncounterClass: MgoCoding?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        participant: [EncounterParticipant]?? = nil,
        period: MgoPeriod?? = nil,
        profile: GpEncounterProfile? = nil,
        reason: [MgoCodeableConcept]?? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        serviceProvider: MgoReference?? = nil
    ) -> GpEncounter {
        return GpEncounter(
            gpEncounterClass: gpEncounterClass ?? self.gpEncounterClass,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            participant: participant ?? self.participant,
            period: period ?? self.period,
            profile: profile ?? self.profile,
            reason: reason ?? self.reason,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            serviceProvider: serviceProvider ?? self.serviceProvider
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
