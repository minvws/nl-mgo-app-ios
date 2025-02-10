// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibMedicationUse = try ZibMedicationUse(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibMedicationUse
public struct ZibMedicationUse: Codable, Hashable, Sendable {
    public let asAgreedIndicator: Bool?
    public let author: MgoReference?
    public let category: MgoCodeableConcept?
    public let dateAsserted: String?
    public let dosage: [ZibInstructionsForUse]?
    public let effectiveDuration: MgoDuration?
    public let effectivePeriod: MgoPeriod?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let informationSource, medicationReference: MgoReference?
    public let medicationTreatment: MgoIdentifier?
    public let note: [MgoAnnotation]?
    public let prescriber: MgoReference?
    public let profile: ZibMedicationUseProfile
    public let reasonCode: [MgoCodeableConcept]?
    public let reasonForChangeOrDiscontinuationOfUse: MgoCodeableConcept?
    public let referenceID: String
    public let repeatPeriodCyclicalSchedule: MgoDuration?
    public let resourceType: String?
    public let status: ZibMedicalDeviceStatus?
    public let subject: MgoReference?
    public let taken: Taken?

    public enum CodingKeys: String, CodingKey {
        case asAgreedIndicator, author, category, dateAsserted, dosage, effectiveDuration, effectivePeriod, fhirVersion, id, identifier, informationSource, medicationReference, medicationTreatment, note, prescriber, profile, reasonCode, reasonForChangeOrDiscontinuationOfUse
        case referenceID = "referenceId"
        case repeatPeriodCyclicalSchedule, resourceType, status, subject, taken
    }

    public init(asAgreedIndicator: Bool?, author: MgoReference?, category: MgoCodeableConcept?, dateAsserted: String?, dosage: [ZibInstructionsForUse]?, effectiveDuration: MgoDuration?, effectivePeriod: MgoPeriod?, fhirVersion: FhirVersionR3, id: String?, identifier: [MgoIdentifier]?, informationSource: MgoReference?, medicationReference: MgoReference?, medicationTreatment: MgoIdentifier?, note: [MgoAnnotation]?, prescriber: MgoReference?, profile: ZibMedicationUseProfile, reasonCode: [MgoCodeableConcept]?, reasonForChangeOrDiscontinuationOfUse: MgoCodeableConcept?, referenceID: String, repeatPeriodCyclicalSchedule: MgoDuration?, resourceType: String?, status: ZibMedicalDeviceStatus?, subject: MgoReference?, taken: Taken?) {
        self.asAgreedIndicator = asAgreedIndicator
        self.author = author
        self.category = category
        self.dateAsserted = dateAsserted
        self.dosage = dosage
        self.effectiveDuration = effectiveDuration
        self.effectivePeriod = effectivePeriod
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.informationSource = informationSource
        self.medicationReference = medicationReference
        self.medicationTreatment = medicationTreatment
        self.note = note
        self.prescriber = prescriber
        self.profile = profile
        self.reasonCode = reasonCode
        self.reasonForChangeOrDiscontinuationOfUse = reasonForChangeOrDiscontinuationOfUse
        self.referenceID = referenceID
        self.repeatPeriodCyclicalSchedule = repeatPeriodCyclicalSchedule
        self.resourceType = resourceType
        self.status = status
        self.subject = subject
        self.taken = taken
    }
}

// MARK: ZibMedicationUse convenience initializers and mutators

public extension ZibMedicationUse {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibMedicationUse.self, from: data)
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
        asAgreedIndicator: Bool?? = nil,
        author: MgoReference?? = nil,
        category: MgoCodeableConcept?? = nil,
        dateAsserted: String?? = nil,
        dosage: [ZibInstructionsForUse]?? = nil,
        effectiveDuration: MgoDuration?? = nil,
        effectivePeriod: MgoPeriod?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        informationSource: MgoReference?? = nil,
        medicationReference: MgoReference?? = nil,
        medicationTreatment: MgoIdentifier?? = nil,
        note: [MgoAnnotation]?? = nil,
        prescriber: MgoReference?? = nil,
        profile: ZibMedicationUseProfile? = nil,
        reasonCode: [MgoCodeableConcept]?? = nil,
        reasonForChangeOrDiscontinuationOfUse: MgoCodeableConcept?? = nil,
        referenceID: String? = nil,
        repeatPeriodCyclicalSchedule: MgoDuration?? = nil,
        resourceType: String?? = nil,
        status: ZibMedicalDeviceStatus?? = nil,
        subject: MgoReference?? = nil,
        taken: Taken?? = nil
    ) -> ZibMedicationUse {
        return ZibMedicationUse(
            asAgreedIndicator: asAgreedIndicator ?? self.asAgreedIndicator,
            author: author ?? self.author,
            category: category ?? self.category,
            dateAsserted: dateAsserted ?? self.dateAsserted,
            dosage: dosage ?? self.dosage,
            effectiveDuration: effectiveDuration ?? self.effectiveDuration,
            effectivePeriod: effectivePeriod ?? self.effectivePeriod,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            informationSource: informationSource ?? self.informationSource,
            medicationReference: medicationReference ?? self.medicationReference,
            medicationTreatment: medicationTreatment ?? self.medicationTreatment,
            note: note ?? self.note,
            prescriber: prescriber ?? self.prescriber,
            profile: profile ?? self.profile,
            reasonCode: reasonCode ?? self.reasonCode,
            reasonForChangeOrDiscontinuationOfUse: reasonForChangeOrDiscontinuationOfUse ?? self.reasonForChangeOrDiscontinuationOfUse,
            referenceID: referenceID ?? self.referenceID,
            repeatPeriodCyclicalSchedule: repeatPeriodCyclicalSchedule ?? self.repeatPeriodCyclicalSchedule,
            resourceType: resourceType ?? self.resourceType,
            status: status ?? self.status,
            subject: subject ?? self.subject,
            taken: taken ?? self.taken
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
