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
    public let dose: MgoDuration?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let note: [MgoAnnotation]?
    public let patient: MgoReference?
    public let practitioner: [Practitioner]?
    public let profile: ZibVaccinationProfile
    public let referenceID: String
    public let resourceType, vaccinationDate: String?
    public let vaccineCode: MgoCodeableConcept?

    public enum CodingKeys: String, CodingKey {
        case dose, fhirVersion, id, identifier, note, patient, practitioner, profile
        case referenceID = "referenceId"
        case resourceType, vaccinationDate, vaccineCode
    }

    public init(dose: MgoDuration?, fhirVersion: FhirVersionR3, id: String?, identifier: [MgoIdentifier]?, note: [MgoAnnotation]?, patient: MgoReference?, practitioner: [Practitioner]?, profile: ZibVaccinationProfile, referenceID: String, resourceType: String?, vaccinationDate: String?, vaccineCode: MgoCodeableConcept?) {
        self.dose = dose
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.note = note
        self.patient = patient
        self.practitioner = practitioner
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.vaccinationDate = vaccinationDate
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
        dose: MgoDuration?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        note: [MgoAnnotation]?? = nil,
        patient: MgoReference?? = nil,
        practitioner: [Practitioner]?? = nil,
        profile: ZibVaccinationProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        vaccinationDate: String?? = nil,
        vaccineCode: MgoCodeableConcept?? = nil
    ) -> ZibVaccination {
        return ZibVaccination(
            dose: dose ?? self.dose,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            note: note ?? self.note,
            patient: patient ?? self.patient,
            practitioner: practitioner ?? self.practitioner,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            vaccinationDate: vaccinationDate ?? self.vaccinationDate,
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
