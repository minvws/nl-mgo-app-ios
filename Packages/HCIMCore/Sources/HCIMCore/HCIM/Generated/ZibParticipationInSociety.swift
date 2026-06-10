// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibParticipationInSociety = try ZibParticipationInSociety(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibParticipationInSociety
public struct ZibParticipationInSociety: Codable, Hashable, Sendable {
    public let comment: MgoString?
    public let component: ZibParticipationInSocietyComponent?
    public let effectiveDateTime: MgoDateTime?
    public let effectivePeriod: MgoPeriod?
    public let fhirVersion: EAfspraakAppointmentFhirVersion
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let performer: [MgoReference]?
    public let profile: ZibParticipationInSocietyProfile
    public let referenceID, resourceType: String
    public let subject: MgoReference?

    public enum CodingKeys: String, CodingKey {
        case comment, component, effectiveDateTime, effectivePeriod, fhirVersion, id, identifier, performer, profile
        case referenceID = "referenceId"
        case resourceType, subject
    }

    public init(comment: MgoString?, component: ZibParticipationInSocietyComponent?, effectiveDateTime: MgoDateTime?, effectivePeriod: MgoPeriod?, fhirVersion: EAfspraakAppointmentFhirVersion, id: String?, identifier: [MgoIdentifier]?, performer: [MgoReference]?, profile: ZibParticipationInSocietyProfile, referenceID: String, resourceType: String, subject: MgoReference?) {
        self.comment = comment
        self.component = component
        self.effectiveDateTime = effectiveDateTime
        self.effectivePeriod = effectivePeriod
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.performer = performer
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.subject = subject
    }
}

// MARK: ZibParticipationInSociety convenience initializers and mutators

public extension ZibParticipationInSociety {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibParticipationInSociety.self, from: data)
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
        comment: MgoString?? = nil,
        component: ZibParticipationInSocietyComponent?? = nil,
        effectiveDateTime: MgoDateTime?? = nil,
        effectivePeriod: MgoPeriod?? = nil,
        fhirVersion: EAfspraakAppointmentFhirVersion? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        performer: [MgoReference]?? = nil,
        profile: ZibParticipationInSocietyProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        subject: MgoReference?? = nil
    ) -> ZibParticipationInSociety {
        return ZibParticipationInSociety(
            comment: comment ?? self.comment,
            component: component ?? self.component,
            effectiveDateTime: effectiveDateTime ?? self.effectiveDateTime,
            effectivePeriod: effectivePeriod ?? self.effectivePeriod,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            performer: performer ?? self.performer,
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
