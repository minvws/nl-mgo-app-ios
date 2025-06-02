// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibBloodPressure = try ZibBloodPressure(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibBloodPressure
public struct ZibBloodPressure: Codable, Hashable, Sendable {
    public let bodySite: MgoCodeableConcept?
    public let comment: MgoString?
    public let component: ZibBloodPressureComponent?
    public let effectiveDateTime: MgoDateTime?
    public let effectivePeriod: MgoPeriod?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let method: MgoCodeableConcept?
    public let performer: [MgoReference]?
    public let profile: ZibBloodPressureProfile
    public let referenceID, resourceType: String
    public let subject: MgoReference?

    public enum CodingKeys: String, CodingKey {
        case bodySite, comment, component, effectiveDateTime, effectivePeriod, fhirVersion, id, identifier, method, performer, profile
        case referenceID = "referenceId"
        case resourceType, subject
    }

    public init(bodySite: MgoCodeableConcept?, comment: MgoString?, component: ZibBloodPressureComponent?, effectiveDateTime: MgoDateTime?, effectivePeriod: MgoPeriod?, fhirVersion: FhirVersionR3, id: String?, identifier: [MgoIdentifier]?, method: MgoCodeableConcept?, performer: [MgoReference]?, profile: ZibBloodPressureProfile, referenceID: String, resourceType: String, subject: MgoReference?) {
        self.bodySite = bodySite
        self.comment = comment
        self.component = component
        self.effectiveDateTime = effectiveDateTime
        self.effectivePeriod = effectivePeriod
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.method = method
        self.performer = performer
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.subject = subject
    }
}

// MARK: ZibBloodPressure convenience initializers and mutators

public extension ZibBloodPressure {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibBloodPressure.self, from: data)
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
        bodySite: MgoCodeableConcept?? = nil,
        comment: MgoString?? = nil,
        component: ZibBloodPressureComponent?? = nil,
        effectiveDateTime: MgoDateTime?? = nil,
        effectivePeriod: MgoPeriod?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        method: MgoCodeableConcept?? = nil,
        performer: [MgoReference]?? = nil,
        profile: ZibBloodPressureProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        subject: MgoReference?? = nil
    ) -> ZibBloodPressure {
        return ZibBloodPressure(
            bodySite: bodySite ?? self.bodySite,
            comment: comment ?? self.comment,
            component: component ?? self.component,
            effectiveDateTime: effectiveDateTime ?? self.effectiveDateTime,
            effectivePeriod: effectivePeriod ?? self.effectivePeriod,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            method: method ?? self.method,
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
