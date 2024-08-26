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
    public let profile: String
    public let asAgreedIndicator: Bool?
    public let author: MgoReference?
    public let category: [MgoCoding]?
    public let dateAsserted: String?
    public let dosage: [Dosage]?
    public let effectiveDuration: MgoQuantity?
    public let effectivePeriod: MgoPeriod?
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let informationSource, medication: MgoReference?
    public let medicationTreatment: MgoIdentifier?
    public let note: [MgoAnnotation]?
    public let prescriber: MgoReference?
    public let reasonCode: [[MgoCoding]]?
    public let reasonForChangeOrDiscontinuationOfUse: [MgoCoding]?
    public let repeatPeriodCyclicalSchedule: MgoQuantity?
    public let resourceType, status: String?
    public let subject: MgoReference?
    public let taken: String?

    public enum CodingKeys: String, CodingKey {
        case profile = "_profile"
        case asAgreedIndicator, author, category, dateAsserted, dosage, effectiveDuration, effectivePeriod, id, identifier, informationSource, medication, medicationTreatment, note, prescriber, reasonCode, reasonForChangeOrDiscontinuationOfUse, repeatPeriodCyclicalSchedule, resourceType, status, subject, taken
    }

    public init(profile: String, asAgreedIndicator: Bool?, author: MgoReference?, category: [MgoCoding]?, dateAsserted: String?, dosage: [Dosage]?, effectiveDuration: MgoQuantity?, effectivePeriod: MgoPeriod?, id: String?, identifier: [MgoIdentifier]?, informationSource: MgoReference?, medication: MgoReference?, medicationTreatment: MgoIdentifier?, note: [MgoAnnotation]?, prescriber: MgoReference?, reasonCode: [[MgoCoding]]?, reasonForChangeOrDiscontinuationOfUse: [MgoCoding]?, repeatPeriodCyclicalSchedule: MgoQuantity?, resourceType: String?, status: String?, subject: MgoReference?, taken: String?) {
        self.profile = profile
        self.asAgreedIndicator = asAgreedIndicator
        self.author = author
        self.category = category
        self.dateAsserted = dateAsserted
        self.dosage = dosage
        self.effectiveDuration = effectiveDuration
        self.effectivePeriod = effectivePeriod
        self.id = id
        self.identifier = identifier
        self.informationSource = informationSource
        self.medication = medication
        self.medicationTreatment = medicationTreatment
        self.note = note
        self.prescriber = prescriber
        self.reasonCode = reasonCode
        self.reasonForChangeOrDiscontinuationOfUse = reasonForChangeOrDiscontinuationOfUse
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
        profile: String? = nil,
        asAgreedIndicator: Bool?? = nil,
        author: MgoReference?? = nil,
        category: [MgoCoding]?? = nil,
        dateAsserted: String?? = nil,
        dosage: [Dosage]?? = nil,
        effectiveDuration: MgoQuantity?? = nil,
        effectivePeriod: MgoPeriod?? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        informationSource: MgoReference?? = nil,
        medication: MgoReference?? = nil,
        medicationTreatment: MgoIdentifier?? = nil,
        note: [MgoAnnotation]?? = nil,
        prescriber: MgoReference?? = nil,
        reasonCode: [[MgoCoding]]?? = nil,
        reasonForChangeOrDiscontinuationOfUse: [MgoCoding]?? = nil,
        repeatPeriodCyclicalSchedule: MgoQuantity?? = nil,
        resourceType: String?? = nil,
        status: String?? = nil,
        subject: MgoReference?? = nil,
        taken: String?? = nil
    ) -> ZibMedicationUse {
        return ZibMedicationUse(
            profile: profile ?? self.profile,
            asAgreedIndicator: asAgreedIndicator ?? self.asAgreedIndicator,
            author: author ?? self.author,
            category: category ?? self.category,
            dateAsserted: dateAsserted ?? self.dateAsserted,
            dosage: dosage ?? self.dosage,
            effectiveDuration: effectiveDuration ?? self.effectiveDuration,
            effectivePeriod: effectivePeriod ?? self.effectivePeriod,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            informationSource: informationSource ?? self.informationSource,
            medication: medication ?? self.medication,
            medicationTreatment: medicationTreatment ?? self.medicationTreatment,
            note: note ?? self.note,
            prescriber: prescriber ?? self.prescriber,
            reasonCode: reasonCode ?? self.reasonCode,
            reasonForChangeOrDiscontinuationOfUse: reasonForChangeOrDiscontinuationOfUse ?? self.reasonForChangeOrDiscontinuationOfUse,
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
