// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibEncounter = try ZibEncounter(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibEncounter
public struct ZibEncounter: Codable, Hashable, Sendable {
    public let zibEncounterClass: MgoCoding?
    public let diagnosis: [ZibEncounterDiagnosis]?
    public let fhirVersion: NlCoreObservationFhirVersion
    public let hospitalization: ZibEncounterHospitalization
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let participant: [ZibEncounterParticipant]?
    public let period: MgoPeriod?
    public let profile: ZibEncounterProfile
    public let reason: [MgoCodeableConcept]?
    public let referenceID, resourceType: String
    public let serviceProvider, subject: MgoReference?

    public enum CodingKeys: String, CodingKey {
        case zibEncounterClass = "class"
        case diagnosis, fhirVersion, hospitalization, id, identifier, participant, period, profile, reason
        case referenceID = "referenceId"
        case resourceType, serviceProvider, subject
    }

    public init(zibEncounterClass: MgoCoding?, diagnosis: [ZibEncounterDiagnosis]?, fhirVersion: NlCoreObservationFhirVersion, hospitalization: ZibEncounterHospitalization, id: String?, identifier: [MgoIdentifier]?, participant: [ZibEncounterParticipant]?, period: MgoPeriod?, profile: ZibEncounterProfile, reason: [MgoCodeableConcept]?, referenceID: String, resourceType: String, serviceProvider: MgoReference?, subject: MgoReference?) {
        self.zibEncounterClass = zibEncounterClass
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

// MARK: ZibEncounter convenience initializers and mutators

public extension ZibEncounter {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibEncounter.self, from: data)
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
        zibEncounterClass: MgoCoding?? = nil,
        diagnosis: [ZibEncounterDiagnosis]?? = nil,
        fhirVersion: NlCoreObservationFhirVersion? = nil,
        hospitalization: ZibEncounterHospitalization? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        participant: [ZibEncounterParticipant]?? = nil,
        period: MgoPeriod?? = nil,
        profile: ZibEncounterProfile? = nil,
        reason: [MgoCodeableConcept]?? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        serviceProvider: MgoReference?? = nil,
        subject: MgoReference?? = nil
    ) -> ZibEncounter {
        return ZibEncounter(
            zibEncounterClass: zibEncounterClass ?? self.zibEncounterClass,
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
