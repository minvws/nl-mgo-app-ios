// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibLaboratoryTestResultObservation = try ZibLaboratoryTestResultObservation(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibLaboratoryTestResultObservation
public struct ZibLaboratoryTestResultObservation: Codable, Hashable, Sendable {
    public let basedOn: [MgoReference]?
    public let code: MgoCodeableConcept?
    public let comment: String?
    public let context: MgoReference?
    public let effectiveDateTime: String?
    public let effectivePeriod: MgoPeriod?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let interpretation: MgoCodeableConcept?
    public let laboratoryTestResultCode: [MgoCodeableConcept]?
    public let method: MgoCodeableConcept?
    public let performer: [MgoReference]?
    public let profile: ZibLaboratoryTestResultObservationProfile
    public let referenceID: String
    public let referenceRange: [ZibLaboratoryTestResultObservationReferenceRange]?
    public let related: [ZibLaboratoryTestResultObservationRelated]?
    public let resourceType: String?
    public let resultType: [MgoCodeableConcept]?
    public let specimen: MgoReference?
    public let status: GpLaboratoryResultStatus?
    public let subject: MgoReference?
    public let valueBoolean: Bool?
    public let valueCodeableConcept: MgoCodeableConcept?
    public let valueDateTime: String?
    public let valuePeriod: MgoPeriod?
    public let valueQuantity: MgoDuration?
    public let valueRange: MgoRange?
    public let valueRatio: MgoRatio?
    public let valueString: String?

    public enum CodingKeys: String, CodingKey {
        case basedOn, code, comment, context, effectiveDateTime, effectivePeriod, fhirVersion, id, identifier, interpretation, laboratoryTestResultCode, method, performer, profile
        case referenceID = "referenceId"
        case referenceRange, related, resourceType, resultType, specimen, status, subject, valueBoolean, valueCodeableConcept, valueDateTime, valuePeriod, valueQuantity, valueRange, valueRatio, valueString
    }

    public init(basedOn: [MgoReference]?, code: MgoCodeableConcept?, comment: String?, context: MgoReference?, effectiveDateTime: String?, effectivePeriod: MgoPeriod?, fhirVersion: FhirVersionR3, id: String?, identifier: [MgoIdentifier]?, interpretation: MgoCodeableConcept?, laboratoryTestResultCode: [MgoCodeableConcept]?, method: MgoCodeableConcept?, performer: [MgoReference]?, profile: ZibLaboratoryTestResultObservationProfile, referenceID: String, referenceRange: [ZibLaboratoryTestResultObservationReferenceRange]?, related: [ZibLaboratoryTestResultObservationRelated]?, resourceType: String?, resultType: [MgoCodeableConcept]?, specimen: MgoReference?, status: GpLaboratoryResultStatus?, subject: MgoReference?, valueBoolean: Bool?, valueCodeableConcept: MgoCodeableConcept?, valueDateTime: String?, valuePeriod: MgoPeriod?, valueQuantity: MgoDuration?, valueRange: MgoRange?, valueRatio: MgoRatio?, valueString: String?) {
        self.basedOn = basedOn
        self.code = code
        self.comment = comment
        self.context = context
        self.effectiveDateTime = effectiveDateTime
        self.effectivePeriod = effectivePeriod
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.interpretation = interpretation
        self.laboratoryTestResultCode = laboratoryTestResultCode
        self.method = method
        self.performer = performer
        self.profile = profile
        self.referenceID = referenceID
        self.referenceRange = referenceRange
        self.related = related
        self.resourceType = resourceType
        self.resultType = resultType
        self.specimen = specimen
        self.status = status
        self.subject = subject
        self.valueBoolean = valueBoolean
        self.valueCodeableConcept = valueCodeableConcept
        self.valueDateTime = valueDateTime
        self.valuePeriod = valuePeriod
        self.valueQuantity = valueQuantity
        self.valueRange = valueRange
        self.valueRatio = valueRatio
        self.valueString = valueString
    }
}

// MARK: ZibLaboratoryTestResultObservation convenience initializers and mutators

public extension ZibLaboratoryTestResultObservation {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibLaboratoryTestResultObservation.self, from: data)
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
        basedOn: [MgoReference]?? = nil,
        code: MgoCodeableConcept?? = nil,
        comment: String?? = nil,
        context: MgoReference?? = nil,
        effectiveDateTime: String?? = nil,
        effectivePeriod: MgoPeriod?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        interpretation: MgoCodeableConcept?? = nil,
        laboratoryTestResultCode: [MgoCodeableConcept]?? = nil,
        method: MgoCodeableConcept?? = nil,
        performer: [MgoReference]?? = nil,
        profile: ZibLaboratoryTestResultObservationProfile? = nil,
        referenceID: String? = nil,
        referenceRange: [ZibLaboratoryTestResultObservationReferenceRange]?? = nil,
        related: [ZibLaboratoryTestResultObservationRelated]?? = nil,
        resourceType: String?? = nil,
        resultType: [MgoCodeableConcept]?? = nil,
        specimen: MgoReference?? = nil,
        status: GpLaboratoryResultStatus?? = nil,
        subject: MgoReference?? = nil,
        valueBoolean: Bool?? = nil,
        valueCodeableConcept: MgoCodeableConcept?? = nil,
        valueDateTime: String?? = nil,
        valuePeriod: MgoPeriod?? = nil,
        valueQuantity: MgoDuration?? = nil,
        valueRange: MgoRange?? = nil,
        valueRatio: MgoRatio?? = nil,
        valueString: String?? = nil
    ) -> ZibLaboratoryTestResultObservation {
        return ZibLaboratoryTestResultObservation(
            basedOn: basedOn ?? self.basedOn,
            code: code ?? self.code,
            comment: comment ?? self.comment,
            context: context ?? self.context,
            effectiveDateTime: effectiveDateTime ?? self.effectiveDateTime,
            effectivePeriod: effectivePeriod ?? self.effectivePeriod,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            interpretation: interpretation ?? self.interpretation,
            laboratoryTestResultCode: laboratoryTestResultCode ?? self.laboratoryTestResultCode,
            method: method ?? self.method,
            performer: performer ?? self.performer,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            referenceRange: referenceRange ?? self.referenceRange,
            related: related ?? self.related,
            resourceType: resourceType ?? self.resourceType,
            resultType: resultType ?? self.resultType,
            specimen: specimen ?? self.specimen,
            status: status ?? self.status,
            subject: subject ?? self.subject,
            valueBoolean: valueBoolean ?? self.valueBoolean,
            valueCodeableConcept: valueCodeableConcept ?? self.valueCodeableConcept,
            valueDateTime: valueDateTime ?? self.valueDateTime,
            valuePeriod: valuePeriod ?? self.valuePeriod,
            valueQuantity: valueQuantity ?? self.valueQuantity,
            valueRange: valueRange ?? self.valueRange,
            valueRatio: valueRatio ?? self.valueRatio,
            valueString: valueString ?? self.valueString
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
