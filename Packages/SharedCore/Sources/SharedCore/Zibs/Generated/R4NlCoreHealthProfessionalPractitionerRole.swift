// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCoreHealthProfessionalPractitionerRole = try R4NlCoreHealthProfessionalPractitionerRole(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCoreHealthProfessionalPractitionerRole
public struct R4NlCoreHealthProfessionalPractitionerRole: Codable, Hashable, Sendable {
    public let fhirVersion: FhirVersionR4
    public let id: String?
    public let organization: MgoReference?
    public let profile: R4NlCoreHealthProfessionalPractitionerRoleProfile
    public let referenceID, resourceType: String
    public let specialty: Specialty
    public let telecom: R4NlCoreHealthProfessionalPractitionerRoleTelecom

    public enum CodingKeys: String, CodingKey {
        case fhirVersion, id, organization, profile
        case referenceID = "referenceId"
        case resourceType, specialty, telecom
    }

    public init(fhirVersion: FhirVersionR4, id: String?, organization: MgoReference?, profile: R4NlCoreHealthProfessionalPractitionerRoleProfile, referenceID: String, resourceType: String, specialty: Specialty, telecom: R4NlCoreHealthProfessionalPractitionerRoleTelecom) {
        self.fhirVersion = fhirVersion
        self.id = id
        self.organization = organization
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.specialty = specialty
        self.telecom = telecom
    }
}

// MARK: R4NlCoreHealthProfessionalPractitionerRole convenience initializers and mutators

public extension R4NlCoreHealthProfessionalPractitionerRole {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCoreHealthProfessionalPractitionerRole.self, from: data)
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
        fhirVersion: FhirVersionR4? = nil,
        id: String?? = nil,
        organization: MgoReference?? = nil,
        profile: R4NlCoreHealthProfessionalPractitionerRoleProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        specialty: Specialty? = nil,
        telecom: R4NlCoreHealthProfessionalPractitionerRoleTelecom? = nil
    ) -> R4NlCoreHealthProfessionalPractitionerRole {
        return R4NlCoreHealthProfessionalPractitionerRole(
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            organization: organization ?? self.organization,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            specialty: specialty ?? self.specialty,
            telecom: telecom ?? self.telecom
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
