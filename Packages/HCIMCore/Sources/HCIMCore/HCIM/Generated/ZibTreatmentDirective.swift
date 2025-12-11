// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibTreatmentDirective = try ZibTreatmentDirective(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibTreatmentDirective
public struct ZibTreatmentDirective: Codable, Hashable, Sendable {
    public let additionalSources: AdditionalSources?
    public let comment: ExtensionValueOfMgoString?
    public let consentingParty: [MgoReference]?
    public let dateTime: PrimitiveValueTypeOfDateTimeDateTimeString?
    public let exceptRestrictions: [ExceptRestriction]?
    public let fhirVersion: NlCoreObservationFhirVersion
    public let id: String?
    public let identifier: MgoIdentifier?
    public let patient: MgoReference?
    public let period: MgoPeriod?
    public let profile: ZibTreatmentDirectiveProfile
    public let referenceID, resourceType: String
    public let sourceAttachment: MgoAttachment?
    public let sourceIdentifier: MgoIdentifier?
    public let sourceReference: MgoReference?
    public let treatment, treatmentPermitted: ExtensionValueOfMgoCodeableConcept?
    public let verification: ExtensionValueOfStructure0_1451595808661854?

    public enum CodingKeys: String, CodingKey {
        case additionalSources, comment, consentingParty, dateTime, exceptRestrictions, fhirVersion, id, identifier, patient, period, profile
        case referenceID = "referenceId"
        case resourceType, sourceAttachment, sourceIdentifier, sourceReference, treatment, treatmentPermitted, verification
    }

    public init(additionalSources: AdditionalSources?, comment: ExtensionValueOfMgoString?, consentingParty: [MgoReference]?, dateTime: PrimitiveValueTypeOfDateTimeDateTimeString?, exceptRestrictions: [ExceptRestriction]?, fhirVersion: NlCoreObservationFhirVersion, id: String?, identifier: MgoIdentifier?, patient: MgoReference?, period: MgoPeriod?, profile: ZibTreatmentDirectiveProfile, referenceID: String, resourceType: String, sourceAttachment: MgoAttachment?, sourceIdentifier: MgoIdentifier?, sourceReference: MgoReference?, treatment: ExtensionValueOfMgoCodeableConcept?, treatmentPermitted: ExtensionValueOfMgoCodeableConcept?, verification: ExtensionValueOfStructure0_1451595808661854?) {
        self.additionalSources = additionalSources
        self.comment = comment
        self.consentingParty = consentingParty
        self.dateTime = dateTime
        self.exceptRestrictions = exceptRestrictions
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.patient = patient
        self.period = period
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.sourceAttachment = sourceAttachment
        self.sourceIdentifier = sourceIdentifier
        self.sourceReference = sourceReference
        self.treatment = treatment
        self.treatmentPermitted = treatmentPermitted
        self.verification = verification
    }
}

// MARK: ZibTreatmentDirective convenience initializers and mutators

public extension ZibTreatmentDirective {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibTreatmentDirective.self, from: data)
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
        additionalSources: AdditionalSources?? = nil,
        comment: ExtensionValueOfMgoString?? = nil,
        consentingParty: [MgoReference]?? = nil,
        dateTime: PrimitiveValueTypeOfDateTimeDateTimeString?? = nil,
        exceptRestrictions: [ExceptRestriction]?? = nil,
        fhirVersion: NlCoreObservationFhirVersion? = nil,
        id: String?? = nil,
        identifier: MgoIdentifier?? = nil,
        patient: MgoReference?? = nil,
        period: MgoPeriod?? = nil,
        profile: ZibTreatmentDirectiveProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        sourceAttachment: MgoAttachment?? = nil,
        sourceIdentifier: MgoIdentifier?? = nil,
        sourceReference: MgoReference?? = nil,
        treatment: ExtensionValueOfMgoCodeableConcept?? = nil,
        treatmentPermitted: ExtensionValueOfMgoCodeableConcept?? = nil,
        verification: ExtensionValueOfStructure0_1451595808661854?? = nil
    ) -> ZibTreatmentDirective {
        return ZibTreatmentDirective(
            additionalSources: additionalSources ?? self.additionalSources,
            comment: comment ?? self.comment,
            consentingParty: consentingParty ?? self.consentingParty,
            dateTime: dateTime ?? self.dateTime,
            exceptRestrictions: exceptRestrictions ?? self.exceptRestrictions,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            patient: patient ?? self.patient,
            period: period ?? self.period,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            sourceAttachment: sourceAttachment ?? self.sourceAttachment,
            sourceIdentifier: sourceIdentifier ?? self.sourceIdentifier,
            sourceReference: sourceReference ?? self.sourceReference,
            treatment: treatment ?? self.treatment,
            treatmentPermitted: treatmentPermitted ?? self.treatmentPermitted,
            verification: verification ?? self.verification
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
