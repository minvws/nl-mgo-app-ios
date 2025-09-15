// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibFunctionalOrMentalStatus = try ZibFunctionalOrMentalStatus(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibFunctionalOrMentalStatus
public struct ZibFunctionalOrMentalStatus: Codable, Hashable, Sendable {
    public let code: MgoCodeableConcept?
    public let comment: PrimitiveValueTypeOfStringString?
    public let effectiveDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?
    public let effectivePeriod: MgoPeriod?
    public let fhirVersion: NlCoreObservationFhirVersion
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let medicalDevice: [ExtensionValueOfMgoReference]
    public let performer: [MgoReference]?
    public let profile: ZibFunctionalOrMentalStatusProfile
    public let referenceID, resourceType: String
    public let subject: MgoReference?
    public let valueCodeableConcept: MgoCodeableConcept?

    public enum CodingKeys: String, CodingKey {
        case code, comment, effectiveDateTime, effectivePeriod, fhirVersion, id, identifier, medicalDevice, performer, profile
        case referenceID = "referenceId"
        case resourceType, subject, valueCodeableConcept
    }

    public init(code: MgoCodeableConcept?, comment: PrimitiveValueTypeOfStringString?, effectiveDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?, effectivePeriod: MgoPeriod?, fhirVersion: NlCoreObservationFhirVersion, id: String?, identifier: [MgoIdentifier]?, medicalDevice: [ExtensionValueOfMgoReference], performer: [MgoReference]?, profile: ZibFunctionalOrMentalStatusProfile, referenceID: String, resourceType: String, subject: MgoReference?, valueCodeableConcept: MgoCodeableConcept?) {
        self.code = code
        self.comment = comment
        self.effectiveDateTime = effectiveDateTime
        self.effectivePeriod = effectivePeriod
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.medicalDevice = medicalDevice
        self.performer = performer
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.subject = subject
        self.valueCodeableConcept = valueCodeableConcept
    }
}

// MARK: ZibFunctionalOrMentalStatus convenience initializers and mutators

public extension ZibFunctionalOrMentalStatus {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibFunctionalOrMentalStatus.self, from: data)
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
        comment: PrimitiveValueTypeOfStringString?? = nil,
        effectiveDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?? = nil,
        effectivePeriod: MgoPeriod?? = nil,
        fhirVersion: NlCoreObservationFhirVersion? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        medicalDevice: [ExtensionValueOfMgoReference]? = nil,
        performer: [MgoReference]?? = nil,
        profile: ZibFunctionalOrMentalStatusProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        subject: MgoReference?? = nil,
        valueCodeableConcept: MgoCodeableConcept?? = nil
    ) -> ZibFunctionalOrMentalStatus {
        return ZibFunctionalOrMentalStatus(
            code: code ?? self.code,
            comment: comment ?? self.comment,
            effectiveDateTime: effectiveDateTime ?? self.effectiveDateTime,
            effectivePeriod: effectivePeriod ?? self.effectivePeriod,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            medicalDevice: medicalDevice ?? self.medicalDevice,
            performer: performer ?? self.performer,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            subject: subject ?? self.subject,
            valueCodeableConcept: valueCodeableConcept ?? self.valueCodeableConcept
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
