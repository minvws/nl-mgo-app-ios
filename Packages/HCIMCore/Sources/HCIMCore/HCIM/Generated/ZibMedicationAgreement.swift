// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibMedicationAgreement = try ZibMedicationAgreement(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibMedicationAgreement
public struct ZibMedicationAgreement: Codable, Hashable, Sendable {
    public let additionalInformation: ExtensionValueOfMgoCodeableConcept?
    public let authoredOn: PrimitiveValueTypeOfDateTimeDateTimeString?
    public let dossageInstruction: [ZibMedicationAgreementDossageInstruction]?
    public let fhirVersion: NlCoreObservationFhirVersion
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let medicationReference: MgoReference?
    public let medicationTreatment: ExtensionValueOfMgoIdentifier?
    public let note: [MgoAnnotation]?
    public let patient: MgoReference?
    public let periodOfUse: ExtensionValueOfMgoPeriod?
    public let profile: ZibMedicationAgreementProfile
    public let reasonCode: [MgoCodeableConcept]?
    public let reasonReference: [MgoReference]?
    public let referenceID: String
    public let repeatPeriodCyclicalSchedule: ExtensionValueOfMgoDuration?
    public let requester: MgoReference?
    public let resourceType: String
    public let stopType: ExtensionValueOfMgoCodeableConcept?
    public let usageDuration: ExtensionValueOfMgoDuration?

    public enum CodingKeys: String, CodingKey {
        case additionalInformation, authoredOn, dossageInstruction, fhirVersion, id, identifier, medicationReference, medicationTreatment, note, patient, periodOfUse, profile, reasonCode, reasonReference
        case referenceID = "referenceId"
        case repeatPeriodCyclicalSchedule, requester, resourceType, stopType, usageDuration
    }

    public init(additionalInformation: ExtensionValueOfMgoCodeableConcept?, authoredOn: PrimitiveValueTypeOfDateTimeDateTimeString?, dossageInstruction: [ZibMedicationAgreementDossageInstruction]?, fhirVersion: NlCoreObservationFhirVersion, id: String?, identifier: [MgoIdentifier]?, medicationReference: MgoReference?, medicationTreatment: ExtensionValueOfMgoIdentifier?, note: [MgoAnnotation]?, patient: MgoReference?, periodOfUse: ExtensionValueOfMgoPeriod?, profile: ZibMedicationAgreementProfile, reasonCode: [MgoCodeableConcept]?, reasonReference: [MgoReference]?, referenceID: String, repeatPeriodCyclicalSchedule: ExtensionValueOfMgoDuration?, requester: MgoReference?, resourceType: String, stopType: ExtensionValueOfMgoCodeableConcept?, usageDuration: ExtensionValueOfMgoDuration?) {
        self.additionalInformation = additionalInformation
        self.authoredOn = authoredOn
        self.dossageInstruction = dossageInstruction
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.medicationReference = medicationReference
        self.medicationTreatment = medicationTreatment
        self.note = note
        self.patient = patient
        self.periodOfUse = periodOfUse
        self.profile = profile
        self.reasonCode = reasonCode
        self.reasonReference = reasonReference
        self.referenceID = referenceID
        self.repeatPeriodCyclicalSchedule = repeatPeriodCyclicalSchedule
        self.requester = requester
        self.resourceType = resourceType
        self.stopType = stopType
        self.usageDuration = usageDuration
    }
}

// MARK: ZibMedicationAgreement convenience initializers and mutators

public extension ZibMedicationAgreement {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibMedicationAgreement.self, from: data)
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
        additionalInformation: ExtensionValueOfMgoCodeableConcept?? = nil,
        authoredOn: PrimitiveValueTypeOfDateTimeDateTimeString?? = nil,
        dossageInstruction: [ZibMedicationAgreementDossageInstruction]?? = nil,
        fhirVersion: NlCoreObservationFhirVersion? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        medicationReference: MgoReference?? = nil,
        medicationTreatment: ExtensionValueOfMgoIdentifier?? = nil,
        note: [MgoAnnotation]?? = nil,
        patient: MgoReference?? = nil,
        periodOfUse: ExtensionValueOfMgoPeriod?? = nil,
        profile: ZibMedicationAgreementProfile? = nil,
        reasonCode: [MgoCodeableConcept]?? = nil,
        reasonReference: [MgoReference]?? = nil,
        referenceID: String? = nil,
        repeatPeriodCyclicalSchedule: ExtensionValueOfMgoDuration?? = nil,
        requester: MgoReference?? = nil,
        resourceType: String? = nil,
        stopType: ExtensionValueOfMgoCodeableConcept?? = nil,
        usageDuration: ExtensionValueOfMgoDuration?? = nil
    ) -> ZibMedicationAgreement {
        return ZibMedicationAgreement(
            additionalInformation: additionalInformation ?? self.additionalInformation,
            authoredOn: authoredOn ?? self.authoredOn,
            dossageInstruction: dossageInstruction ?? self.dossageInstruction,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            medicationReference: medicationReference ?? self.medicationReference,
            medicationTreatment: medicationTreatment ?? self.medicationTreatment,
            note: note ?? self.note,
            patient: patient ?? self.patient,
            periodOfUse: periodOfUse ?? self.periodOfUse,
            profile: profile ?? self.profile,
            reasonCode: reasonCode ?? self.reasonCode,
            reasonReference: reasonReference ?? self.reasonReference,
            referenceID: referenceID ?? self.referenceID,
            repeatPeriodCyclicalSchedule: repeatPeriodCyclicalSchedule ?? self.repeatPeriodCyclicalSchedule,
            requester: requester ?? self.requester,
            resourceType: resourceType ?? self.resourceType,
            stopType: stopType ?? self.stopType,
            usageDuration: usageDuration ?? self.usageDuration
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
