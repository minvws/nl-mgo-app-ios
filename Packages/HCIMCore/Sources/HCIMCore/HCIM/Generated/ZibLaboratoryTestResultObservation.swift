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
    public let category: ZibLaboratoryTestResultObservationCategory
    public let code: MgoCodeableConcept?
    public let comment: MgoString?
    public let context: MgoReference?
    public let effectiveDateTime: MgoDateTime?
    public let effectivePeriod: MgoPeriod?
    public let fhirVersion: EAfspraakAppointmentFhirVersion
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let interpretation: ZibLaboratoryTestResultObservationInterpretation
    public let method: MgoCodeableConcept?
    public let performer: [MgoReference]?
    public let profile: ZibLaboratoryTestResultObservationProfile
    public let referenceID: String
    public let referenceRange: [ZibLaboratoryTestResultObservationReferenceRange]?
    public let related: [ZibLaboratoryTestResultObservationRelated]?
    public let resourceType: String
    public let specimen: MgoReference?
    public let status: ZibLaboratoryTestResultObservationStatus
    public let subject: MgoReference?
    public let valueAttachment: MgoAttachment?
    public let valueBoolean: MgoBoolean?
    public let valueCodeableConcept: MgoCodeableConcept?
    public let valueDateTime: MgoDateTime?
    public let valuePeriod: MgoPeriod?
    public let valueQuantity: MgoQuantity?
    public let valueRange: MgoRange?
    public let valueRatio: MgoRatio?
    public let valueSampledData: MgoSampledData?
    public let valueString: MgoString?
    public let valueTime: MgoTime?

    public enum CodingKeys: String, CodingKey {
        case basedOn, category, code, comment, context, effectiveDateTime, effectivePeriod, fhirVersion, id, identifier, interpretation, method, performer, profile
        case referenceID = "referenceId"
        case referenceRange, related, resourceType, specimen, status, subject, valueAttachment, valueBoolean, valueCodeableConcept, valueDateTime, valuePeriod, valueQuantity, valueRange, valueRatio, valueSampledData, valueString, valueTime
    }

    public init(basedOn: [MgoReference]?, category: ZibLaboratoryTestResultObservationCategory, code: MgoCodeableConcept?, comment: MgoString?, context: MgoReference?, effectiveDateTime: MgoDateTime?, effectivePeriod: MgoPeriod?, fhirVersion: EAfspraakAppointmentFhirVersion, id: String?, identifier: [MgoIdentifier]?, interpretation: ZibLaboratoryTestResultObservationInterpretation, method: MgoCodeableConcept?, performer: [MgoReference]?, profile: ZibLaboratoryTestResultObservationProfile, referenceID: String, referenceRange: [ZibLaboratoryTestResultObservationReferenceRange]?, related: [ZibLaboratoryTestResultObservationRelated]?, resourceType: String, specimen: MgoReference?, status: ZibLaboratoryTestResultObservationStatus, subject: MgoReference?, valueAttachment: MgoAttachment?, valueBoolean: MgoBoolean?, valueCodeableConcept: MgoCodeableConcept?, valueDateTime: MgoDateTime?, valuePeriod: MgoPeriod?, valueQuantity: MgoQuantity?, valueRange: MgoRange?, valueRatio: MgoRatio?, valueSampledData: MgoSampledData?, valueString: MgoString?, valueTime: MgoTime?) {
        self.basedOn = basedOn
        self.category = category
        self.code = code
        self.comment = comment
        self.context = context
        self.effectiveDateTime = effectiveDateTime
        self.effectivePeriod = effectivePeriod
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.interpretation = interpretation
        self.method = method
        self.performer = performer
        self.profile = profile
        self.referenceID = referenceID
        self.referenceRange = referenceRange
        self.related = related
        self.resourceType = resourceType
        self.specimen = specimen
        self.status = status
        self.subject = subject
        self.valueAttachment = valueAttachment
        self.valueBoolean = valueBoolean
        self.valueCodeableConcept = valueCodeableConcept
        self.valueDateTime = valueDateTime
        self.valuePeriod = valuePeriod
        self.valueQuantity = valueQuantity
        self.valueRange = valueRange
        self.valueRatio = valueRatio
        self.valueSampledData = valueSampledData
        self.valueString = valueString
        self.valueTime = valueTime
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
        category: ZibLaboratoryTestResultObservationCategory? = nil,
        code: MgoCodeableConcept?? = nil,
        comment: MgoString?? = nil,
        context: MgoReference?? = nil,
        effectiveDateTime: MgoDateTime?? = nil,
        effectivePeriod: MgoPeriod?? = nil,
        fhirVersion: EAfspraakAppointmentFhirVersion? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        interpretation: ZibLaboratoryTestResultObservationInterpretation? = nil,
        method: MgoCodeableConcept?? = nil,
        performer: [MgoReference]?? = nil,
        profile: ZibLaboratoryTestResultObservationProfile? = nil,
        referenceID: String? = nil,
        referenceRange: [ZibLaboratoryTestResultObservationReferenceRange]?? = nil,
        related: [ZibLaboratoryTestResultObservationRelated]?? = nil,
        resourceType: String? = nil,
        specimen: MgoReference?? = nil,
        status: ZibLaboratoryTestResultObservationStatus? = nil,
        subject: MgoReference?? = nil,
        valueAttachment: MgoAttachment?? = nil,
        valueBoolean: MgoBoolean?? = nil,
        valueCodeableConcept: MgoCodeableConcept?? = nil,
        valueDateTime: MgoDateTime?? = nil,
        valuePeriod: MgoPeriod?? = nil,
        valueQuantity: MgoQuantity?? = nil,
        valueRange: MgoRange?? = nil,
        valueRatio: MgoRatio?? = nil,
        valueSampledData: MgoSampledData?? = nil,
        valueString: MgoString?? = nil,
        valueTime: MgoTime?? = nil
    ) -> ZibLaboratoryTestResultObservation {
        return ZibLaboratoryTestResultObservation(
            basedOn: basedOn ?? self.basedOn,
            category: category ?? self.category,
            code: code ?? self.code,
            comment: comment ?? self.comment,
            context: context ?? self.context,
            effectiveDateTime: effectiveDateTime ?? self.effectiveDateTime,
            effectivePeriod: effectivePeriod ?? self.effectivePeriod,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            interpretation: interpretation ?? self.interpretation,
            method: method ?? self.method,
            performer: performer ?? self.performer,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            referenceRange: referenceRange ?? self.referenceRange,
            related: related ?? self.related,
            resourceType: resourceType ?? self.resourceType,
            specimen: specimen ?? self.specimen,
            status: status ?? self.status,
            subject: subject ?? self.subject,
            valueAttachment: valueAttachment ?? self.valueAttachment,
            valueBoolean: valueBoolean ?? self.valueBoolean,
            valueCodeableConcept: valueCodeableConcept ?? self.valueCodeableConcept,
            valueDateTime: valueDateTime ?? self.valueDateTime,
            valuePeriod: valuePeriod ?? self.valuePeriod,
            valueQuantity: valueQuantity ?? self.valueQuantity,
            valueRange: valueRange ?? self.valueRange,
            valueRatio: valueRatio ?? self.valueRatio,
            valueSampledData: valueSampledData ?? self.valueSampledData,
            valueString: valueString ?? self.valueString,
            valueTime: valueTime ?? self.valueTime
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
