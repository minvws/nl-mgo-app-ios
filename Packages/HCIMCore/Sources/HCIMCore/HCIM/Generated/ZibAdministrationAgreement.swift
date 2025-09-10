// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibAdministrationAgreement = try ZibAdministrationAgreement(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibAdministrationAgreement
public struct ZibAdministrationAgreement: Codable, Hashable, Sendable {
    public let additionalInformation: ExtensionValueOfMgoCodeableConcept?
    public let agreementReason: ExtensionValueOfMgoString?
    public let authoredOn: ExtensionValueOfMgoDateTime?
    public let authorizingPrescription: [MgoReference]?
    public let dossageInstruction: [ZibAdministrationAgreementDossageInstruction]?
    public let fhirVersion: NlCoreObservationFhirVersion
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let medicationReference: MgoReference?
    public let medicationTreatment: ExtensionValueOfMgoIdentifier?
    public let note: [MgoAnnotation]?
    public let patient: MgoReference?
    public let performer: [ZibAdministrationAgreementPerformer]?
    public let periodOfUse: ExtensionValueOfMgoPeriod?
    public let profile: ZibAdministrationAgreementProfile
    public let referenceID: String
    public let repeatPeriodCyclicalSchedule: ExtensionValueOfMgoDuration?
    public let resourceType: String
    public let status: MgoCodeOfEnteredInErrorPreparationInProgressOnHoldCompletedStopped?
    public let stopType: ExtensionValueOfMgoCodeableConcept?
    public let usageDuration: ExtensionValueOfMgoDuration?

    public enum CodingKeys: String, CodingKey {
        case additionalInformation, agreementReason, authoredOn, authorizingPrescription, dossageInstruction, fhirVersion, id, identifier, medicationReference, medicationTreatment, note, patient, performer, periodOfUse, profile
        case referenceID = "referenceId"
        case repeatPeriodCyclicalSchedule, resourceType, status, stopType, usageDuration
    }

    public init(additionalInformation: ExtensionValueOfMgoCodeableConcept?, agreementReason: ExtensionValueOfMgoString?, authoredOn: ExtensionValueOfMgoDateTime?, authorizingPrescription: [MgoReference]?, dossageInstruction: [ZibAdministrationAgreementDossageInstruction]?, fhirVersion: NlCoreObservationFhirVersion, id: String?, identifier: [MgoIdentifier]?, medicationReference: MgoReference?, medicationTreatment: ExtensionValueOfMgoIdentifier?, note: [MgoAnnotation]?, patient: MgoReference?, performer: [ZibAdministrationAgreementPerformer]?, periodOfUse: ExtensionValueOfMgoPeriod?, profile: ZibAdministrationAgreementProfile, referenceID: String, repeatPeriodCyclicalSchedule: ExtensionValueOfMgoDuration?, resourceType: String, status: MgoCodeOfEnteredInErrorPreparationInProgressOnHoldCompletedStopped?, stopType: ExtensionValueOfMgoCodeableConcept?, usageDuration: ExtensionValueOfMgoDuration?) {
        self.additionalInformation = additionalInformation
        self.agreementReason = agreementReason
        self.authoredOn = authoredOn
        self.authorizingPrescription = authorizingPrescription
        self.dossageInstruction = dossageInstruction
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.medicationReference = medicationReference
        self.medicationTreatment = medicationTreatment
        self.note = note
        self.patient = patient
        self.performer = performer
        self.periodOfUse = periodOfUse
        self.profile = profile
        self.referenceID = referenceID
        self.repeatPeriodCyclicalSchedule = repeatPeriodCyclicalSchedule
        self.resourceType = resourceType
        self.status = status
        self.stopType = stopType
        self.usageDuration = usageDuration
    }
}

// MARK: ZibAdministrationAgreement convenience initializers and mutators

public extension ZibAdministrationAgreement {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibAdministrationAgreement.self, from: data)
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
        agreementReason: ExtensionValueOfMgoString?? = nil,
        authoredOn: ExtensionValueOfMgoDateTime?? = nil,
        authorizingPrescription: [MgoReference]?? = nil,
        dossageInstruction: [ZibAdministrationAgreementDossageInstruction]?? = nil,
        fhirVersion: NlCoreObservationFhirVersion? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        medicationReference: MgoReference?? = nil,
        medicationTreatment: ExtensionValueOfMgoIdentifier?? = nil,
        note: [MgoAnnotation]?? = nil,
        patient: MgoReference?? = nil,
        performer: [ZibAdministrationAgreementPerformer]?? = nil,
        periodOfUse: ExtensionValueOfMgoPeriod?? = nil,
        profile: ZibAdministrationAgreementProfile? = nil,
        referenceID: String? = nil,
        repeatPeriodCyclicalSchedule: ExtensionValueOfMgoDuration?? = nil,
        resourceType: String? = nil,
        status: MgoCodeOfEnteredInErrorPreparationInProgressOnHoldCompletedStopped?? = nil,
        stopType: ExtensionValueOfMgoCodeableConcept?? = nil,
        usageDuration: ExtensionValueOfMgoDuration?? = nil
    ) -> ZibAdministrationAgreement {
        return ZibAdministrationAgreement(
            additionalInformation: additionalInformation ?? self.additionalInformation,
            agreementReason: agreementReason ?? self.agreementReason,
            authoredOn: authoredOn ?? self.authoredOn,
            authorizingPrescription: authorizingPrescription ?? self.authorizingPrescription,
            dossageInstruction: dossageInstruction ?? self.dossageInstruction,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            medicationReference: medicationReference ?? self.medicationReference,
            medicationTreatment: medicationTreatment ?? self.medicationTreatment,
            note: note ?? self.note,
            patient: patient ?? self.patient,
            performer: performer ?? self.performer,
            periodOfUse: periodOfUse ?? self.periodOfUse,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            repeatPeriodCyclicalSchedule: repeatPeriodCyclicalSchedule ?? self.repeatPeriodCyclicalSchedule,
            resourceType: resourceType ?? self.resourceType,
            status: status ?? self.status,
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
