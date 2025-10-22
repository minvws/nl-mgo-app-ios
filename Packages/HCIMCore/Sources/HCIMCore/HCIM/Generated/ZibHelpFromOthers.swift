// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibHelpFromOthers = try ZibHelpFromOthers(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibHelpFromOthers
public struct ZibHelpFromOthers: Codable, Hashable, Sendable {
    public let activity: [ZibHelpFromOthersActivity]?
    public let fhirVersion: NlCoreObservationFhirVersion
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let period: MgoPeriod?
    public let profile: ZibHelpFromOthersProfile
    public let referenceID, resourceType: String
    public let subject: MgoReference?

    public enum CodingKeys: String, CodingKey {
        case activity, fhirVersion, id, identifier, period, profile
        case referenceID = "referenceId"
        case resourceType, subject
    }

    public init(activity: [ZibHelpFromOthersActivity]?, fhirVersion: NlCoreObservationFhirVersion, id: String?, identifier: [MgoIdentifier]?, period: MgoPeriod?, profile: ZibHelpFromOthersProfile, referenceID: String, resourceType: String, subject: MgoReference?) {
        self.activity = activity
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.period = period
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.subject = subject
    }
}

// MARK: ZibHelpFromOthers convenience initializers and mutators

public extension ZibHelpFromOthers {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibHelpFromOthers.self, from: data)
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
        activity: [ZibHelpFromOthersActivity]?? = nil,
        fhirVersion: NlCoreObservationFhirVersion? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        period: MgoPeriod?? = nil,
        profile: ZibHelpFromOthersProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        subject: MgoReference?? = nil
    ) -> ZibHelpFromOthers {
        return ZibHelpFromOthers(
            activity: activity ?? self.activity,
            fhirVersion: fhirVersion ?? self.fhirVersion,
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
