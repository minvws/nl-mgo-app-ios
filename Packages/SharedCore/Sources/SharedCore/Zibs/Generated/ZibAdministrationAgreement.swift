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
    public let additionalInformation: MgoCodeableConcept?
    public let agreementReason, authoredOn: String?
    public let authorizingPrescription: [MgoReference]?
    public let category: MgoCodeableConcept?
    public let daysSupply: MgoDuration?
    public let dossageInstruction: [ZibInstructionsForUse]?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let medicationReference: MgoReference?
    public let medicationTreatment: MgoIdentifier?
    public let note: [MgoAnnotation]?
    public let performer: [ZibAdministrationAgreementPerformer]?
    public let periodOfUse: MgoPeriod?
    public let profile: ZibAdministrationAgreementProfile
    public let quantity: MgoDuration?
    public let referenceID: String
    public let repeatPeriodCyclicalSchedule: MgoDuration?
    public let resourceType: String?
    public let status: ZibAdministrationAgreementStatus?
    public let stopType: MgoCodeableConcept?
    public let usageDuration: MgoDuration?

    public enum CodingKeys: String, CodingKey {
        case additionalInformation, agreementReason, authoredOn, authorizingPrescription, category, daysSupply, dossageInstruction, fhirVersion, id, identifier, medicationReference, medicationTreatment, note, performer, periodOfUse, profile, quantity
        case referenceID = "referenceId"
        case repeatPeriodCyclicalSchedule, resourceType, status, stopType, usageDuration
    }

    public init(additionalInformation: MgoCodeableConcept?, agreementReason: String?, authoredOn: String?, authorizingPrescription: [MgoReference]?, category: MgoCodeableConcept?, daysSupply: MgoDuration?, dossageInstruction: [ZibInstructionsForUse]?, fhirVersion: FhirVersionR3, id: String?, identifier: [MgoIdentifier]?, medicationReference: MgoReference?, medicationTreatment: MgoIdentifier?, note: [MgoAnnotation]?, performer: [ZibAdministrationAgreementPerformer]?, periodOfUse: MgoPeriod?, profile: ZibAdministrationAgreementProfile, quantity: MgoDuration?, referenceID: String, repeatPeriodCyclicalSchedule: MgoDuration?, resourceType: String?, status: ZibAdministrationAgreementStatus?, stopType: MgoCodeableConcept?, usageDuration: MgoDuration?) {
        self.additionalInformation = additionalInformation
        self.agreementReason = agreementReason
        self.authoredOn = authoredOn
        self.authorizingPrescription = authorizingPrescription
        self.category = category
        self.daysSupply = daysSupply
        self.dossageInstruction = dossageInstruction
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.medicationReference = medicationReference
        self.medicationTreatment = medicationTreatment
        self.note = note
        self.performer = performer
        self.periodOfUse = periodOfUse
        self.profile = profile
        self.quantity = quantity
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
        additionalInformation: MgoCodeableConcept?? = nil,
        agreementReason: String?? = nil,
        authoredOn: String?? = nil,
        authorizingPrescription: [MgoReference]?? = nil,
        category: MgoCodeableConcept?? = nil,
        daysSupply: MgoDuration?? = nil,
        dossageInstruction: [ZibInstructionsForUse]?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        medicationReference: MgoReference?? = nil,
        medicationTreatment: MgoIdentifier?? = nil,
        note: [MgoAnnotation]?? = nil,
        performer: [ZibAdministrationAgreementPerformer]?? = nil,
        periodOfUse: MgoPeriod?? = nil,
        profile: ZibAdministrationAgreementProfile? = nil,
        quantity: MgoDuration?? = nil,
        referenceID: String? = nil,
        repeatPeriodCyclicalSchedule: MgoDuration?? = nil,
        resourceType: String?? = nil,
        status: ZibAdministrationAgreementStatus?? = nil,
        stopType: MgoCodeableConcept?? = nil,
        usageDuration: MgoDuration?? = nil
    ) -> ZibAdministrationAgreement {
        return ZibAdministrationAgreement(
            additionalInformation: additionalInformation ?? self.additionalInformation,
            agreementReason: agreementReason ?? self.agreementReason,
            authoredOn: authoredOn ?? self.authoredOn,
            authorizingPrescription: authorizingPrescription ?? self.authorizingPrescription,
            category: category ?? self.category,
            daysSupply: daysSupply ?? self.daysSupply,
            dossageInstruction: dossageInstruction ?? self.dossageInstruction,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            medicationReference: medicationReference ?? self.medicationReference,
            medicationTreatment: medicationTreatment ?? self.medicationTreatment,
            note: note ?? self.note,
            performer: performer ?? self.performer,
            periodOfUse: periodOfUse ?? self.periodOfUse,
            profile: profile ?? self.profile,
            quantity: quantity ?? self.quantity,
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
