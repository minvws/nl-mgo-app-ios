// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibGeneralMeasurement = try ZibGeneralMeasurement(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibGeneralMeasurement
public struct ZibGeneralMeasurement: Codable, Hashable, Sendable {
    public let bodySite, code: MgoCodeableConcept?
    public let comment: PrimitiveValueTypeOfStringString?
    public let effectiveDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?
    public let effectivePeriod: MgoPeriod?
    public let fhirVersion: NlCoreObservationFhirVersion
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let method: MgoCodeableConcept?
    public let performer: [MgoReference]?
    public let profile: ZibGeneralMeasurementProfile
    public let referenceID: String
    public let related: [ZibGeneralMeasurementRelated]?
    public let resourceType: String
    public let status: ZibGeneralMeasurementStatus
    public let subject: MgoReference?
    public let valueAttachment: MgoAttachment?
    public let valueBoolean: PrimitiveValueTypeOfBooleanBoolean?
    public let valueCodeableConcept: MgoCodeableConcept?
    public let valueDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?
    public let valuePeriod: MgoPeriod?
    public let valueQuantity: MgoQuantity?
    public let valueRange: MgoRange?
    public let valueRatio: MgoRatio?
    public let valueSampledData: MgoSampledData?
    public let valueString: PrimitiveValueTypeOfStringString?
    public let valueTime: PrimitiveValueTypeOfTimeTimeString?

    public enum CodingKeys: String, CodingKey {
        case bodySite, code, comment, effectiveDateTime, effectivePeriod, fhirVersion, id, identifier, method, performer, profile
        case referenceID = "referenceId"
        case related, resourceType, status, subject, valueAttachment, valueBoolean, valueCodeableConcept, valueDateTime, valuePeriod, valueQuantity, valueRange, valueRatio, valueSampledData, valueString, valueTime
    }

    public init(bodySite: MgoCodeableConcept?, code: MgoCodeableConcept?, comment: PrimitiveValueTypeOfStringString?, effectiveDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?, effectivePeriod: MgoPeriod?, fhirVersion: NlCoreObservationFhirVersion, id: String?, identifier: [MgoIdentifier]?, method: MgoCodeableConcept?, performer: [MgoReference]?, profile: ZibGeneralMeasurementProfile, referenceID: String, related: [ZibGeneralMeasurementRelated]?, resourceType: String, status: ZibGeneralMeasurementStatus, subject: MgoReference?, valueAttachment: MgoAttachment?, valueBoolean: PrimitiveValueTypeOfBooleanBoolean?, valueCodeableConcept: MgoCodeableConcept?, valueDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?, valuePeriod: MgoPeriod?, valueQuantity: MgoQuantity?, valueRange: MgoRange?, valueRatio: MgoRatio?, valueSampledData: MgoSampledData?, valueString: PrimitiveValueTypeOfStringString?, valueTime: PrimitiveValueTypeOfTimeTimeString?) {
        self.bodySite = bodySite
        self.code = code
        self.comment = comment
        self.effectiveDateTime = effectiveDateTime
        self.effectivePeriod = effectivePeriod
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.method = method
        self.performer = performer
        self.profile = profile
        self.referenceID = referenceID
        self.related = related
        self.resourceType = resourceType
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

// MARK: ZibGeneralMeasurement convenience initializers and mutators

public extension ZibGeneralMeasurement {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibGeneralMeasurement.self, from: data)
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
        code: MgoCodeableConcept?? = nil,
        comment: PrimitiveValueTypeOfStringString?? = nil,
        effectiveDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?? = nil,
        effectivePeriod: MgoPeriod?? = nil,
        fhirVersion: NlCoreObservationFhirVersion? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        method: MgoCodeableConcept?? = nil,
        performer: [MgoReference]?? = nil,
        profile: ZibGeneralMeasurementProfile? = nil,
        referenceID: String? = nil,
        related: [ZibGeneralMeasurementRelated]?? = nil,
        resourceType: String? = nil,
        status: ZibGeneralMeasurementStatus? = nil,
        subject: MgoReference?? = nil,
        valueAttachment: MgoAttachment?? = nil,
        valueBoolean: PrimitiveValueTypeOfBooleanBoolean?? = nil,
        valueCodeableConcept: MgoCodeableConcept?? = nil,
        valueDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?? = nil,
        valuePeriod: MgoPeriod?? = nil,
        valueQuantity: MgoQuantity?? = nil,
        valueRange: MgoRange?? = nil,
        valueRatio: MgoRatio?? = nil,
        valueSampledData: MgoSampledData?? = nil,
        valueString: PrimitiveValueTypeOfStringString?? = nil,
        valueTime: PrimitiveValueTypeOfTimeTimeString?? = nil
    ) -> ZibGeneralMeasurement {
        return ZibGeneralMeasurement(
            bodySite: bodySite ?? self.bodySite,
            code: code ?? self.code,
            comment: comment ?? self.comment,
            effectiveDateTime: effectiveDateTime ?? self.effectiveDateTime,
            effectivePeriod: effectivePeriod ?? self.effectivePeriod,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            method: method ?? self.method,
            performer: performer ?? self.performer,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            related: related ?? self.related,
            resourceType: resourceType ?? self.resourceType,
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
