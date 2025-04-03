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
    public let averageBloodPressureLOINC: AverageBloodPressureLOINC
    public let averageBloodPressureSNOMED: AverageBloodPressureSNOMED
    public let bodySite: MgoCodeableConcept?
    public let category: [MgoCodeableConcept]?
    public let comment: String?
    public let context: MgoReference?
    public let cuffTypeLOINC: CuffTypeLOINC
    public let cuffTypeSNOMED: CuffTypeSNOMED
    public let dataAbsentReason: MgoCodeableConcept?
    public let diastolicBP: DiastolicBP
    public let diastolicEndpoint: DiastolicEndpoint
    public let effectiveDateTime: String?
    public let effectivePeriod: MgoPeriod?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let method: MgoCodeableConcept?
    public let positionLOINC: PositionLOINC
    public let positionSNOMED: PositionSNOMED
    public let profile: ZibBloodPressureProfile
    public let referenceID: String
    public let resourceType: String?
    public let status: GpLaboratoryResultStatus?
    public let subject: MgoReference?
    public let systolicBP: SystolicBP
    public let valueCodeableConcept: MgoCodeableConcept?
    public let valueQuantity: MgoDuration?

    public enum CodingKeys: String, CodingKey {
        case averageBloodPressureLOINC, averageBloodPressureSNOMED, bodySite, category, comment, context, cuffTypeLOINC, cuffTypeSNOMED, dataAbsentReason, diastolicBP, diastolicEndpoint, effectiveDateTime, effectivePeriod, fhirVersion, id, identifier, method, positionLOINC, positionSNOMED, profile
        case referenceID = "referenceId"
        case resourceType, status, subject, systolicBP, valueCodeableConcept, valueQuantity
    }

    public init(averageBloodPressureLOINC: AverageBloodPressureLOINC, averageBloodPressureSNOMED: AverageBloodPressureSNOMED, bodySite: MgoCodeableConcept?, category: [MgoCodeableConcept]?, comment: String?, context: MgoReference?, cuffTypeLOINC: CuffTypeLOINC, cuffTypeSNOMED: CuffTypeSNOMED, dataAbsentReason: MgoCodeableConcept?, diastolicBP: DiastolicBP, diastolicEndpoint: DiastolicEndpoint, effectiveDateTime: String?, effectivePeriod: MgoPeriod?, fhirVersion: FhirVersionR3, id: String?, identifier: [MgoIdentifier]?, method: MgoCodeableConcept?, positionLOINC: PositionLOINC, positionSNOMED: PositionSNOMED, profile: ZibBloodPressureProfile, referenceID: String, resourceType: String?, status: GpLaboratoryResultStatus?, subject: MgoReference?, systolicBP: SystolicBP, valueCodeableConcept: MgoCodeableConcept?, valueQuantity: MgoDuration?) {
        self.averageBloodPressureLOINC = averageBloodPressureLOINC
        self.averageBloodPressureSNOMED = averageBloodPressureSNOMED
        self.bodySite = bodySite
        self.category = category
        self.comment = comment
        self.context = context
        self.cuffTypeLOINC = cuffTypeLOINC
        self.cuffTypeSNOMED = cuffTypeSNOMED
        self.dataAbsentReason = dataAbsentReason
        self.diastolicBP = diastolicBP
        self.diastolicEndpoint = diastolicEndpoint
        self.effectiveDateTime = effectiveDateTime
        self.effectivePeriod = effectivePeriod
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.method = method
        self.positionLOINC = positionLOINC
        self.positionSNOMED = positionSNOMED
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.status = status
        self.subject = subject
        self.systolicBP = systolicBP
        self.valueCodeableConcept = valueCodeableConcept
        self.valueQuantity = valueQuantity
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
        averageBloodPressureLOINC: AverageBloodPressureLOINC? = nil,
        averageBloodPressureSNOMED: AverageBloodPressureSNOMED? = nil,
        bodySite: MgoCodeableConcept?? = nil,
        category: [MgoCodeableConcept]?? = nil,
        comment: String?? = nil,
        context: MgoReference?? = nil,
        cuffTypeLOINC: CuffTypeLOINC? = nil,
        cuffTypeSNOMED: CuffTypeSNOMED? = nil,
        dataAbsentReason: MgoCodeableConcept?? = nil,
        diastolicBP: DiastolicBP? = nil,
        diastolicEndpoint: DiastolicEndpoint? = nil,
        effectiveDateTime: String?? = nil,
        effectivePeriod: MgoPeriod?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        method: MgoCodeableConcept?? = nil,
        positionLOINC: PositionLOINC? = nil,
        positionSNOMED: PositionSNOMED? = nil,
        profile: ZibBloodPressureProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        status: GpLaboratoryResultStatus?? = nil,
        subject: MgoReference?? = nil,
        systolicBP: SystolicBP? = nil,
        valueCodeableConcept: MgoCodeableConcept?? = nil,
        valueQuantity: MgoDuration?? = nil
    ) -> ZibBloodPressure {
        return ZibBloodPressure(
            averageBloodPressureLOINC: averageBloodPressureLOINC ?? self.averageBloodPressureLOINC,
            averageBloodPressureSNOMED: averageBloodPressureSNOMED ?? self.averageBloodPressureSNOMED,
            bodySite: bodySite ?? self.bodySite,
            category: category ?? self.category,
            comment: comment ?? self.comment,
            context: context ?? self.context,
            cuffTypeLOINC: cuffTypeLOINC ?? self.cuffTypeLOINC,
            cuffTypeSNOMED: cuffTypeSNOMED ?? self.cuffTypeSNOMED,
            dataAbsentReason: dataAbsentReason ?? self.dataAbsentReason,
            diastolicBP: diastolicBP ?? self.diastolicBP,
            diastolicEndpoint: diastolicEndpoint ?? self.diastolicEndpoint,
            effectiveDateTime: effectiveDateTime ?? self.effectiveDateTime,
            effectivePeriod: effectivePeriod ?? self.effectivePeriod,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            method: method ?? self.method,
            positionLOINC: positionLOINC ?? self.positionLOINC,
            positionSNOMED: positionSNOMED ?? self.positionSNOMED,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            status: status ?? self.status,
            subject: subject ?? self.subject,
            systolicBP: systolicBP ?? self.systolicBP,
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
