// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibLivingSituation = try ZibLivingSituation(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibLivingSituation
public struct ZibLivingSituation: Codable, Hashable, Sendable {
    public let bodySite: MgoCodeableConcept?
    public let category: [MgoCodeableConcept]?
    public let comment: String?
    public let context: MgoReference?
    public let dataAbsentReason: MgoCodeableConcept?
    public let effectiveDateTime: String?
    public let effectivePeriod: MgoPeriod?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let method: MgoCodeableConcept?
    public let profile: ZibLivingSituationProfile
    public let referenceID: String
    public let resourceType: String?
    public let status: GpLaboratoryResultStatus?
    public let subject: MgoReference?
    public let valueCodeableConcept: MgoCodeableConcept?
    public let valueQuantity: MgoDuration?

    public enum CodingKeys: String, CodingKey {
        case bodySite, category, comment, context, dataAbsentReason, effectiveDateTime, effectivePeriod, fhirVersion, id, identifier, method, profile
        case referenceID = "referenceId"
        case resourceType, status, subject, valueCodeableConcept, valueQuantity
    }

    public init(bodySite: MgoCodeableConcept?, category: [MgoCodeableConcept]?, comment: String?, context: MgoReference?, dataAbsentReason: MgoCodeableConcept?, effectiveDateTime: String?, effectivePeriod: MgoPeriod?, fhirVersion: FhirVersionR3, id: String?, identifier: [MgoIdentifier]?, method: MgoCodeableConcept?, profile: ZibLivingSituationProfile, referenceID: String, resourceType: String?, status: GpLaboratoryResultStatus?, subject: MgoReference?, valueCodeableConcept: MgoCodeableConcept?, valueQuantity: MgoDuration?) {
        self.bodySite = bodySite
        self.category = category
        self.comment = comment
        self.context = context
        self.dataAbsentReason = dataAbsentReason
        self.effectiveDateTime = effectiveDateTime
        self.effectivePeriod = effectivePeriod
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.method = method
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.status = status
        self.subject = subject
        self.valueCodeableConcept = valueCodeableConcept
        self.valueQuantity = valueQuantity
    }
}

// MARK: ZibLivingSituation convenience initializers and mutators

public extension ZibLivingSituation {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibLivingSituation.self, from: data)
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
        category: [MgoCodeableConcept]?? = nil,
        comment: String?? = nil,
        context: MgoReference?? = nil,
        dataAbsentReason: MgoCodeableConcept?? = nil,
        effectiveDateTime: String?? = nil,
        effectivePeriod: MgoPeriod?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        method: MgoCodeableConcept?? = nil,
        profile: ZibLivingSituationProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        status: GpLaboratoryResultStatus?? = nil,
        subject: MgoReference?? = nil,
        valueCodeableConcept: MgoCodeableConcept?? = nil,
        valueQuantity: MgoDuration?? = nil
    ) -> ZibLivingSituation {
        return ZibLivingSituation(
            bodySite: bodySite ?? self.bodySite,
            category: category ?? self.category,
            comment: comment ?? self.comment,
            context: context ?? self.context,
            dataAbsentReason: dataAbsentReason ?? self.dataAbsentReason,
            effectiveDateTime: effectiveDateTime ?? self.effectiveDateTime,
            effectivePeriod: effectivePeriod ?? self.effectivePeriod,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            method: method ?? self.method,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            status: status ?? self.status,
            subject: subject ?? self.subject,
            valueCodeableConcept: valueCodeableConcept ?? self.valueCodeableConcept,
            valueQuantity: valueQuantity ?? self.valueQuantity
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
