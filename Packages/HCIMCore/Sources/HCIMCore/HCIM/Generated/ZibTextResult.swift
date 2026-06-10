// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibTextResult = try ZibTextResult(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibTextResult
public struct ZibTextResult: Codable, Hashable, Sendable {
    public let code: MgoCodeableConcept?
    public let conclusion: MgoString?
    public let effectiveDateTime: MgoDateTime?
    public let effectivePeriod: MgoPeriod?
    public let fhirVersion: EAfspraakAppointmentFhirVersion
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let performer: [ZibTextResultPerformer]?
    public let profile: ZibTextResultProfile
    public let referenceID, resourceType: String
    public let status: ExtensionValueOfMgoCodeableConcept?
    public let subject: MgoReference?

    public enum CodingKeys: String, CodingKey {
        case code, conclusion, effectiveDateTime, effectivePeriod, fhirVersion, id, identifier, performer, profile
        case referenceID = "referenceId"
        case resourceType, status, subject
    }

    public init(code: MgoCodeableConcept?, conclusion: MgoString?, effectiveDateTime: MgoDateTime?, effectivePeriod: MgoPeriod?, fhirVersion: EAfspraakAppointmentFhirVersion, id: String?, identifier: [MgoIdentifier]?, performer: [ZibTextResultPerformer]?, profile: ZibTextResultProfile, referenceID: String, resourceType: String, status: ExtensionValueOfMgoCodeableConcept?, subject: MgoReference?) {
        self.code = code
        self.conclusion = conclusion
        self.effectiveDateTime = effectiveDateTime
        self.effectivePeriod = effectivePeriod
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.performer = performer
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.status = status
        self.subject = subject
    }
}

// MARK: ZibTextResult convenience initializers and mutators

public extension ZibTextResult {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibTextResult.self, from: data)
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
        code: MgoCodeableConcept?? = nil,
        conclusion: MgoString?? = nil,
        effectiveDateTime: MgoDateTime?? = nil,
        effectivePeriod: MgoPeriod?? = nil,
        fhirVersion: EAfspraakAppointmentFhirVersion? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        performer: [ZibTextResultPerformer]?? = nil,
        profile: ZibTextResultProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        status: ExtensionValueOfMgoCodeableConcept?? = nil,
        subject: MgoReference?? = nil
    ) -> ZibTextResult {
        return ZibTextResult(
            code: code ?? self.code,
            conclusion: conclusion ?? self.conclusion,
            effectiveDateTime: effectiveDateTime ?? self.effectiveDateTime,
            effectivePeriod: effectivePeriod ?? self.effectivePeriod,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            performer: performer ?? self.performer,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            status: status ?? self.status,
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
