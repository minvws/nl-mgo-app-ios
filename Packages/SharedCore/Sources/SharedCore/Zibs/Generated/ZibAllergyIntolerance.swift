// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibAllergyIntolerance = try ZibAllergyIntolerance(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibAllergyIntolerance
public struct ZibAllergyIntolerance: Codable, Hashable, Sendable {
    public let category: [String]?
    public let clinicalStatus: ZibAllergyIntoleranceClinicalStatus?
    public let code: MgoCodeableConcept?
    public let criticality: Criticality?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let patient: MgoReference?
    public let profile: ZibAllergyIntoleranceProfile
    public let referenceID: String
    public let resourceType: String?
    public let type: ZibAllergyIntoleranceType?
    public let verificationStatus: ZibAllergyIntoleranceVerificationStatus?

    public enum CodingKeys: String, CodingKey {
        case category, clinicalStatus, code, criticality, fhirVersion, id, identifier, patient, profile
        case referenceID = "referenceId"
        case resourceType, type, verificationStatus
    }

    public init(category: [String]?, clinicalStatus: ZibAllergyIntoleranceClinicalStatus?, code: MgoCodeableConcept?, criticality: Criticality?, fhirVersion: FhirVersionR3, id: String?, identifier: [MgoIdentifier]?, patient: MgoReference?, profile: ZibAllergyIntoleranceProfile, referenceID: String, resourceType: String?, type: ZibAllergyIntoleranceType?, verificationStatus: ZibAllergyIntoleranceVerificationStatus?) {
        self.category = category
        self.clinicalStatus = clinicalStatus
        self.code = code
        self.criticality = criticality
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.patient = patient
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.type = type
        self.verificationStatus = verificationStatus
    }
}

// MARK: ZibAllergyIntolerance convenience initializers and mutators

public extension ZibAllergyIntolerance {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibAllergyIntolerance.self, from: data)
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
        category: [String]?? = nil,
        clinicalStatus: ZibAllergyIntoleranceClinicalStatus?? = nil,
        code: MgoCodeableConcept?? = nil,
        criticality: Criticality?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        patient: MgoReference?? = nil,
        profile: ZibAllergyIntoleranceProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        type: ZibAllergyIntoleranceType?? = nil,
        verificationStatus: ZibAllergyIntoleranceVerificationStatus?? = nil
    ) -> ZibAllergyIntolerance {
        return ZibAllergyIntolerance(
            category: category ?? self.category,
            clinicalStatus: clinicalStatus ?? self.clinicalStatus,
            code: code ?? self.code,
            criticality: criticality ?? self.criticality,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            patient: patient ?? self.patient,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            type: type ?? self.type,
            verificationStatus: verificationStatus ?? self.verificationStatus
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
