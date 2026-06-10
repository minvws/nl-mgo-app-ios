// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibLaboratoryTestResultSubstance = try ZibLaboratoryTestResultSubstance(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibLaboratoryTestResultSubstance
public struct ZibLaboratoryTestResultSubstance: Codable, Hashable, Sendable {
    public let code: MgoCodeableConcept?
    public let fhirVersion: EAfspraakAppointmentFhirVersion
    public let id: String?
    public let profile: ZibLaboratoryTestResultSubstanceProfile
    public let referenceID, resourceType: String

    public enum CodingKeys: String, CodingKey {
        case code, fhirVersion, id, profile
        case referenceID = "referenceId"
        case resourceType
    }

    public init(code: MgoCodeableConcept?, fhirVersion: EAfspraakAppointmentFhirVersion, id: String?, profile: ZibLaboratoryTestResultSubstanceProfile, referenceID: String, resourceType: String) {
        self.code = code
        self.fhirVersion = fhirVersion
        self.id = id
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
    }
}

// MARK: ZibLaboratoryTestResultSubstance convenience initializers and mutators

public extension ZibLaboratoryTestResultSubstance {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibLaboratoryTestResultSubstance.self, from: data)
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
        code: MgoCodeableConcept?? = nil,
        fhirVersion: EAfspraakAppointmentFhirVersion? = nil,
        id: String?? = nil,
        profile: ZibLaboratoryTestResultSubstanceProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil
    ) -> ZibLaboratoryTestResultSubstance {
        return ZibLaboratoryTestResultSubstance(
            code: code ?? self.code,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
