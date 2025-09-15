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
    public let diagnosis: [GpEncounterDiagnosis]?
    public let fhirVersion: NlCoreObservationFhirVersion
    public let hospitalization: GpEncounterHospitalization
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let participant: [GpEncounterParticipant]?
    public let period: MgoPeriod?
    public let profile: GpEncounterProfile
    public let reason: [MgoCodeableConcept]?
    public let referenceID, resourceType: String
    public let serviceProvider, subject: MgoReference?

    public enum CodingKeys: String, CodingKey {
        case gpEncounterClass = "class"
        case diagnosis, fhirVersion, hospitalization, id, identifier, participant, period, profile, reason
        case referenceID = "referenceId"
        case resourceType, serviceProvider, subject
    }

    public init(gpEncounterClass: MgoCoding?, diagnosis: [GpEncounterDiagnosis]?, fhirVersion: NlCoreObservationFhirVersion, hospitalization: GpEncounterHospitalization, id: String?, identifier: [MgoIdentifier]?, participant: [GpEncounterParticipant]?, period: MgoPeriod?, profile: GpEncounterProfile, reason: [MgoCodeableConcept]?, referenceID: String, resourceType: String, serviceProvider: MgoReference?, subject: MgoReference?) {
        self.gpEncounterClass = gpEncounterClass
        self.diagnosis = diagnosis
        self.fhirVersion = fhirVersion
        self.hospitalization = hospitalization
        self.id = id
        self.identifier = identifier
        self.participant = participant
        self.period = period
        self.profile = profile
        self.reason = reason
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.serviceProvider = serviceProvider
        self.subject = subject
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
        diagnosis: [GpEncounterDiagnosis]?? = nil,
        fhirVersion: NlCoreObservationFhirVersion? = nil,
        hospitalization: GpEncounterHospitalization? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        participant: [GpEncounterParticipant]?? = nil,
        period: MgoPeriod?? = nil,
        profile: GpEncounterProfile? = nil,
        reason: [MgoCodeableConcept]?? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        serviceProvider: MgoReference?? = nil,
        subject: MgoReference?? = nil
    ) -> GpEncounter {
        return GpEncounter(
            gpEncounterClass: gpEncounterClass ?? self.gpEncounterClass,
            diagnosis: diagnosis ?? self.diagnosis,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            hospitalization: hospitalization ?? self.hospitalization,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            participant: participant ?? self.participant,
            period: period ?? self.period,
            profile: profile ?? self.profile,
            reason: reason ?? self.reason,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            serviceProvider: serviceProvider ?? self.serviceProvider,
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
