// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibVaccination = try ZibVaccination(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibVaccination
public struct ZibVaccination: Codable, Hashable, Sendable {
    public let date: MgoDate?
    public let doseQuantity: MgoQuantity?
    public let fhirVersion: EAfspraakAppointmentFhirVersion
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let note: [MgoAnnotation]?
    public let patient: MgoReference?
    public let practitioner: [Practitioner]?
    public let profile: ZibVaccinationProfile
    public let referenceID: String
    public let reportOrigin: MgoCodeableConcept?
    public let resourceType: String
    public let vaccineCode: MgoCodeableConcept?

    public enum CodingKeys: String, CodingKey {
        case date, doseQuantity, fhirVersion, id, identifier, note, patient, practitioner, profile
        case referenceID = "referenceId"
        case reportOrigin, resourceType, vaccineCode
    }

    public init(date: MgoDate?, doseQuantity: MgoQuantity?, fhirVersion: EAfspraakAppointmentFhirVersion, id: String?, identifier: [MgoIdentifier]?, note: [MgoAnnotation]?, patient: MgoReference?, practitioner: [Practitioner]?, profile: ZibVaccinationProfile, referenceID: String, reportOrigin: MgoCodeableConcept?, resourceType: String, vaccineCode: MgoCodeableConcept?) {
        self.date = date
        self.doseQuantity = doseQuantity
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.note = note
        self.patient = patient
        self.practitioner = practitioner
        self.profile = profile
        self.referenceID = referenceID
        self.reportOrigin = reportOrigin
        self.resourceType = resourceType
        self.vaccineCode = vaccineCode
    }
}

// MARK: ZibVaccination convenience initializers and mutators

public extension ZibVaccination {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibVaccination.self, from: data)
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
        date: MgoDate?? = nil,
        doseQuantity: MgoQuantity?? = nil,
        fhirVersion: EAfspraakAppointmentFhirVersion? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        note: [MgoAnnotation]?? = nil,
        patient: MgoReference?? = nil,
        practitioner: [Practitioner]?? = nil,
        profile: ZibVaccinationProfile? = nil,
        referenceID: String? = nil,
        reportOrigin: MgoCodeableConcept?? = nil,
        resourceType: String? = nil,
        vaccineCode: MgoCodeableConcept?? = nil
    ) -> ZibVaccination {
        return ZibVaccination(
            date: date ?? self.date,
            doseQuantity: doseQuantity ?? self.doseQuantity,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            note: note ?? self.note,
            patient: patient ?? self.patient,
            practitioner: practitioner ?? self.practitioner,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            reportOrigin: reportOrigin ?? self.reportOrigin,
            resourceType: resourceType ?? self.resourceType,
            vaccineCode: vaccineCode ?? self.vaccineCode
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
