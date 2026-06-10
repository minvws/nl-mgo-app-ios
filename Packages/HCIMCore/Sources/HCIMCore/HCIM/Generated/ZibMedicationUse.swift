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
    public let asAgreedIndicator: ExtensionValueOfMgoBoolean?
    public let author: ExtensionValueOfMgoReference?
    public let dateAsserted: MgoDateTime?
    public let dosage: [Dosage]?
    public let effectivePeriod: EffectivePeriod
    public let fhirVersion: EAfspraakAppointmentFhirVersion
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let informationSource, medicationReference: MgoReference?
    public let medicationTreatment: ExtensionValueOfMgoIdentifier?
    public let note: [MgoAnnotation]?
    public let prescriber: ExtensionValueOfMgoReference?
    public let profile: ZibMedicationUseProfile
    public let reasonCode: [MgoCodeableConcept]?
    public let reasonForChangeOrDiscontinuationOfUse: ExtensionValueOfMgoCodeableConcept?
    public let referenceID: String
    public let repeatPeriodCyclicalSchedule: ExtensionValueOfMgoDuration?
    public let resourceType: String
    public let status: MgoCodeOfString?
    public let subject: MgoReference?
    public let taken: MgoCodeOfString?

    public enum CodingKeys: String, CodingKey {
        case asAgreedIndicator, author, dateAsserted, dosage, effectivePeriod, fhirVersion, id, identifier, informationSource, medicationReference, medicationTreatment, note, prescriber, profile, reasonCode, reasonForChangeOrDiscontinuationOfUse
        case referenceID = "referenceId"
        case repeatPeriodCyclicalSchedule, resourceType, status, subject, taken
    }

    public init(asAgreedIndicator: ExtensionValueOfMgoBoolean?, author: ExtensionValueOfMgoReference?, dateAsserted: MgoDateTime?, dosage: [Dosage]?, effectivePeriod: EffectivePeriod, fhirVersion: EAfspraakAppointmentFhirVersion, id: String?, identifier: [MgoIdentifier]?, informationSource: MgoReference?, medicationReference: MgoReference?, medicationTreatment: ExtensionValueOfMgoIdentifier?, note: [MgoAnnotation]?, prescriber: ExtensionValueOfMgoReference?, profile: ZibMedicationUseProfile, reasonCode: [MgoCodeableConcept]?, reasonForChangeOrDiscontinuationOfUse: ExtensionValueOfMgoCodeableConcept?, referenceID: String, repeatPeriodCyclicalSchedule: ExtensionValueOfMgoDuration?, resourceType: String, status: MgoCodeOfString?, subject: MgoReference?, taken: MgoCodeOfString?) {
        self.asAgreedIndicator = asAgreedIndicator
        self.author = author
        self.dateAsserted = dateAsserted
        self.dosage = dosage
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
        asAgreedIndicator: ExtensionValueOfMgoBoolean?? = nil,
        author: ExtensionValueOfMgoReference?? = nil,
        dateAsserted: MgoDateTime?? = nil,
        dosage: [Dosage]?? = nil,
        effectivePeriod: EffectivePeriod? = nil,
        fhirVersion: EAfspraakAppointmentFhirVersion? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        informationSource: MgoReference?? = nil,
        medicationReference: MgoReference?? = nil,
        medicationTreatment: ExtensionValueOfMgoIdentifier?? = nil,
        note: [MgoAnnotation]?? = nil,
        prescriber: ExtensionValueOfMgoReference?? = nil,
        profile: ZibMedicationUseProfile? = nil,
        reasonCode: [MgoCodeableConcept]?? = nil,
        reasonForChangeOrDiscontinuationOfUse: ExtensionValueOfMgoCodeableConcept?? = nil,
        referenceID: String? = nil,
        repeatPeriodCyclicalSchedule: ExtensionValueOfMgoDuration?? = nil,
        resourceType: String? = nil,
        status: MgoCodeOfString?? = nil,
        subject: MgoReference?? = nil,
        taken: MgoCodeOfString?? = nil
    ) -> ZibMedicationUse {
        return ZibMedicationUse(
            asAgreedIndicator: asAgreedIndicator ?? self.asAgreedIndicator,
            author: author ?? self.author,
            dateAsserted: dateAsserted ?? self.dateAsserted,
            dosage: dosage ?? self.dosage,
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
