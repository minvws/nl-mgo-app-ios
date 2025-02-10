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
    public let basedOn: [MgoReference]?
    public let category: MgoCodeableConcept?
    public let definition: [MgoReference]?
    public let dossageInstruction: [ZibInstructionsForUse]?
    public let fhirVersion: FhirVersionR3
    public let groupIdentifier: MgoIdentifier?
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let intent: Intent?
    public let medicationReference: MgoReference?
    public let medicationTreatment: MgoIdentifier?
    public let note: [MgoAnnotation]?
    public let periodOfUse: MgoPeriod?
    public let priority: Priority?
    public let profile: ZibMedicationAgreementProfile
    public let referenceID: String
    public let repeatPeriodCyclicalSchedule: MgoDuration?
    public let resourceType: String?
    public let status: ZibMedicationAgreementStatus?
    public let stopType: MgoCodeableConcept?
    public let usageDuration: MgoDuration?

    public enum CodingKeys: String, CodingKey {
        case basedOn, category, definition, dossageInstruction, fhirVersion, groupIdentifier, id, identifier, intent, medicationReference, medicationTreatment, note, periodOfUse, priority, profile
        case referenceID = "referenceId"
        case repeatPeriodCyclicalSchedule, resourceType, status, stopType, usageDuration
    }

    public init(basedOn: [MgoReference]?, category: MgoCodeableConcept?, definition: [MgoReference]?, dossageInstruction: [ZibInstructionsForUse]?, fhirVersion: FhirVersionR3, groupIdentifier: MgoIdentifier?, id: String?, identifier: [MgoIdentifier]?, intent: Intent?, medicationReference: MgoReference?, medicationTreatment: MgoIdentifier?, note: [MgoAnnotation]?, periodOfUse: MgoPeriod?, priority: Priority?, profile: ZibMedicationAgreementProfile, referenceID: String, repeatPeriodCyclicalSchedule: MgoDuration?, resourceType: String?, status: ZibMedicationAgreementStatus?, stopType: MgoCodeableConcept?, usageDuration: MgoDuration?) {
        self.basedOn = basedOn
        self.category = category
        self.definition = definition
        self.dossageInstruction = dossageInstruction
        self.fhirVersion = fhirVersion
        self.groupIdentifier = groupIdentifier
        self.id = id
        self.identifier = identifier
        self.intent = intent
        self.medicationReference = medicationReference
        self.medicationTreatment = medicationTreatment
        self.note = note
        self.periodOfUse = periodOfUse
        self.priority = priority
        self.profile = profile
        self.referenceID = referenceID
        self.repeatPeriodCyclicalSchedule = repeatPeriodCyclicalSchedule
        self.resourceType = resourceType
        self.status = status
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
        basedOn: [MgoReference]?? = nil,
        category: MgoCodeableConcept?? = nil,
        definition: [MgoReference]?? = nil,
        dossageInstruction: [ZibInstructionsForUse]?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        groupIdentifier: MgoIdentifier?? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        intent: Intent?? = nil,
        medicationReference: MgoReference?? = nil,
        medicationTreatment: MgoIdentifier?? = nil,
        note: [MgoAnnotation]?? = nil,
        periodOfUse: MgoPeriod?? = nil,
        priority: Priority?? = nil,
        profile: ZibMedicationAgreementProfile? = nil,
        referenceID: String? = nil,
        repeatPeriodCyclicalSchedule: MgoDuration?? = nil,
        resourceType: String?? = nil,
        status: ZibMedicationAgreementStatus?? = nil,
        stopType: MgoCodeableConcept?? = nil,
        usageDuration: MgoDuration?? = nil
    ) -> ZibMedicationAgreement {
        return ZibMedicationAgreement(
            basedOn: basedOn ?? self.basedOn,
            category: category ?? self.category,
            definition: definition ?? self.definition,
            dossageInstruction: dossageInstruction ?? self.dossageInstruction,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            groupIdentifier: groupIdentifier ?? self.groupIdentifier,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            intent: intent ?? self.intent,
            medicationReference: medicationReference ?? self.medicationReference,
            medicationTreatment: medicationTreatment ?? self.medicationTreatment,
            note: note ?? self.note,
            periodOfUse: periodOfUse ?? self.periodOfUse,
            priority: priority ?? self.priority,
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
