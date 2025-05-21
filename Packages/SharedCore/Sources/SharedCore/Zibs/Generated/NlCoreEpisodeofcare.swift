// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCoreEpisodeofcare = try NlCoreEpisodeofcare(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCoreEpisodeofcare
public struct NlCoreEpisodeofcare: Codable, Hashable, Sendable {
    public let account: [MgoReference]?
    public let careManager: MgoReference?
    public let dateFirstEncounter, dateLastEncounter: String?
    public let diagnosis: [NlCoreEpisodeofcareDiagnosis]?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let managingOrganization, patient: MgoReference?
    public let period: MgoPeriod?
    public let profile: NlCoreEpisodeofcareProfile
    public let referenceID: String
    public let referralRequest: [MgoReference]?
    public let resourceType: String?
    public let status: NlCoreEpisodeofcareStatus?
    public let statusHistory: [StatusHistory]?
    public let team: [MgoReference]?
    public let title: String?
    public let type: [MgoCodeableConcept]?

    public enum CodingKeys: String, CodingKey {
        case account, careManager, dateFirstEncounter, dateLastEncounter, diagnosis, fhirVersion, id, identifier, managingOrganization, patient, period, profile
        case referenceID = "referenceId"
        case referralRequest, resourceType, status, statusHistory, team, title, type
    }

    public init(account: [MgoReference]?, careManager: MgoReference?, dateFirstEncounter: String?, dateLastEncounter: String?, diagnosis: [NlCoreEpisodeofcareDiagnosis]?, fhirVersion: FhirVersionR3, id: String?, identifier: [MgoIdentifier]?, managingOrganization: MgoReference?, patient: MgoReference?, period: MgoPeriod?, profile: NlCoreEpisodeofcareProfile, referenceID: String, referralRequest: [MgoReference]?, resourceType: String?, status: NlCoreEpisodeofcareStatus?, statusHistory: [StatusHistory]?, team: [MgoReference]?, title: String?, type: [MgoCodeableConcept]?) {
        self.account = account
        self.careManager = careManager
        self.dateFirstEncounter = dateFirstEncounter
        self.dateLastEncounter = dateLastEncounter
        self.diagnosis = diagnosis
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.managingOrganization = managingOrganization
        self.patient = patient
        self.period = period
        self.profile = profile
        self.referenceID = referenceID
        self.referralRequest = referralRequest
        self.resourceType = resourceType
        self.status = status
        self.statusHistory = statusHistory
        self.team = team
        self.title = title
        self.type = type
    }
}

// MARK: NlCoreEpisodeofcare convenience initializers and mutators

public extension NlCoreEpisodeofcare {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCoreEpisodeofcare.self, from: data)
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
        account: [MgoReference]?? = nil,
        careManager: MgoReference?? = nil,
        dateFirstEncounter: String?? = nil,
        dateLastEncounter: String?? = nil,
        diagnosis: [NlCoreEpisodeofcareDiagnosis]?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        managingOrganization: MgoReference?? = nil,
        patient: MgoReference?? = nil,
        period: MgoPeriod?? = nil,
        profile: NlCoreEpisodeofcareProfile? = nil,
        referenceID: String? = nil,
        referralRequest: [MgoReference]?? = nil,
        resourceType: String?? = nil,
        status: NlCoreEpisodeofcareStatus?? = nil,
        statusHistory: [StatusHistory]?? = nil,
        team: [MgoReference]?? = nil,
        title: String?? = nil,
        type: [MgoCodeableConcept]?? = nil
    ) -> NlCoreEpisodeofcare {
        return NlCoreEpisodeofcare(
            account: account ?? self.account,
            careManager: careManager ?? self.careManager,
            dateFirstEncounter: dateFirstEncounter ?? self.dateFirstEncounter,
            dateLastEncounter: dateLastEncounter ?? self.dateLastEncounter,
            diagnosis: diagnosis ?? self.diagnosis,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            managingOrganization: managingOrganization ?? self.managingOrganization,
            patient: patient ?? self.patient,
            period: period ?? self.period,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            referralRequest: referralRequest ?? self.referralRequest,
            resourceType: resourceType ?? self.resourceType,
            status: status ?? self.status,
            statusHistory: statusHistory ?? self.statusHistory,
            team: team ?? self.team,
            title: title ?? self.title,
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
