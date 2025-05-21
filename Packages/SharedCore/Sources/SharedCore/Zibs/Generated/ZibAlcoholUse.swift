// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibAlcoholUse = try ZibAlcoholUse(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibAlcoholUse
public struct ZibAlcoholUse: Codable, Hashable, Sendable {
    public let bodySite: MgoCodeableConcept?
    public let category: [MgoCodeableConcept]?
    public let comment: String?
    public let component: Component
    public let context: MgoReference?
    public let dataAbsentReason: MgoCodeableConcept?
    public let effectivePeriod: MgoPeriod?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let method: MgoCodeableConcept?
    public let performer: [MgoReference]?
    public let profile: ZibAlcoholUseProfile
    public let referenceID: String
    public let resourceType: String?
    public let status: GpLaboratoryResultStatus?
    public let subject: MgoReference?
    public let valueCodeableConcept: MgoCodeableConcept?
    public let valueQuantity: MgoDuration?

    public enum CodingKeys: String, CodingKey {
        case bodySite, category, comment, component, context, dataAbsentReason, effectivePeriod, fhirVersion, id, identifier, method, performer, profile
        case referenceID = "referenceId"
        case resourceType, status, subject, valueCodeableConcept, valueQuantity
    }

    public init(bodySite: MgoCodeableConcept?, category: [MgoCodeableConcept]?, comment: String?, component: Component, context: MgoReference?, dataAbsentReason: MgoCodeableConcept?, effectivePeriod: MgoPeriod?, fhirVersion: FhirVersionR3, id: String?, identifier: [MgoIdentifier]?, method: MgoCodeableConcept?, performer: [MgoReference]?, profile: ZibAlcoholUseProfile, referenceID: String, resourceType: String?, status: GpLaboratoryResultStatus?, subject: MgoReference?, valueCodeableConcept: MgoCodeableConcept?, valueQuantity: MgoDuration?) {
        self.bodySite = bodySite
        self.category = category
        self.comment = comment
        self.component = component
        self.context = context
        self.dataAbsentReason = dataAbsentReason
        self.effectivePeriod = effectivePeriod
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.method = method
        self.performer = performer
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.status = status
        self.subject = subject
        self.valueCodeableConcept = valueCodeableConcept
        self.valueQuantity = valueQuantity
    }
}

// MARK: ZibAlcoholUse convenience initializers and mutators

public extension ZibAlcoholUse {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibAlcoholUse.self, from: data)
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
        component: Component? = nil,
        context: MgoReference?? = nil,
        dataAbsentReason: MgoCodeableConcept?? = nil,
        effectivePeriod: MgoPeriod?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        method: MgoCodeableConcept?? = nil,
        performer: [MgoReference]?? = nil,
        profile: ZibAlcoholUseProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        status: GpLaboratoryResultStatus?? = nil,
        subject: MgoReference?? = nil,
        valueCodeableConcept: MgoCodeableConcept?? = nil,
        valueQuantity: MgoDuration?? = nil
    ) -> ZibAlcoholUse {
        return ZibAlcoholUse(
            bodySite: bodySite ?? self.bodySite,
            category: category ?? self.category,
            comment: comment ?? self.comment,
            component: component ?? self.component,
            context: context ?? self.context,
            dataAbsentReason: dataAbsentReason ?? self.dataAbsentReason,
            effectivePeriod: effectivePeriod ?? self.effectivePeriod,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            method: method ?? self.method,
            performer: performer ?? self.performer,
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
