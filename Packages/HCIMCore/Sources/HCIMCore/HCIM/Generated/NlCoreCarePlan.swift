// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCoreCarePlan = try NlCoreCarePlan(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCoreCarePlan
public struct NlCoreCarePlan: Codable, Hashable, Sendable {
    public let activity: [NlCoreCarePlanActivity]?
    public let fhirVersion: EAfspraakAppointmentFhirVersion
    public let goal: [MgoReference]?
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let period: MgoPeriod?
    public let profile: NlCoreCarePlanProfile
    public let referenceID, resourceType: String
    public let subject: MgoReference?

    public enum CodingKeys: String, CodingKey {
        case activity, fhirVersion, goal, id, identifier, period, profile
        case referenceID = "referenceId"
        case resourceType, subject
    }

    public init(activity: [NlCoreCarePlanActivity]?, fhirVersion: EAfspraakAppointmentFhirVersion, goal: [MgoReference]?, id: String?, identifier: [MgoIdentifier]?, period: MgoPeriod?, profile: NlCoreCarePlanProfile, referenceID: String, resourceType: String, subject: MgoReference?) {
        self.activity = activity
        self.fhirVersion = fhirVersion
        self.goal = goal
        self.id = id
        self.identifier = identifier
        self.period = period
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.subject = subject
    }
}

// MARK: NlCoreCarePlan convenience initializers and mutators

public extension NlCoreCarePlan {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCoreCarePlan.self, from: data)
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
        activity: [NlCoreCarePlanActivity]?? = nil,
        fhirVersion: EAfspraakAppointmentFhirVersion? = nil,
        goal: [MgoReference]?? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        period: MgoPeriod?? = nil,
        profile: NlCoreCarePlanProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        subject: MgoReference?? = nil
    ) -> NlCoreCarePlan {
        return NlCoreCarePlan(
            activity: activity ?? self.activity,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            goal: goal ?? self.goal,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
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
