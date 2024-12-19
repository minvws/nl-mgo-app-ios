// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCoreHealthProfessionalPractitionerRole = try NlCoreHealthProfessionalPractitionerRole(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCoreHealthProfessionalPractitionerRole
public struct NlCoreHealthProfessionalPractitionerRole: Codable, Hashable, Sendable {
    public let emailAddresses: [NlCoreHealthProfessionalPractitionerRoleEmailAddress]?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let location: [MgoReference]?
    public let organization, practitioner: MgoReference?
    public let profile: NlCoreHealthProfessionalPractitionerRoleProfile
    public let referenceID: String
    public let resourceType: String?
    public let speciality: [MgoCodeableConcept]?
    public let telephoneNumbers: [NlCoreHealthProfessionalPractitionerRoleTelephoneNumber]?

    public enum CodingKeys: String, CodingKey {
        case emailAddresses, fhirVersion, id, location, organization, practitioner, profile
        case referenceID = "referenceId"
        case resourceType, speciality, telephoneNumbers
    }

    public init(emailAddresses: [NlCoreHealthProfessionalPractitionerRoleEmailAddress]?, fhirVersion: FhirVersionR3, id: String?, location: [MgoReference]?, organization: MgoReference?, practitioner: MgoReference?, profile: NlCoreHealthProfessionalPractitionerRoleProfile, referenceID: String, resourceType: String?, speciality: [MgoCodeableConcept]?, telephoneNumbers: [NlCoreHealthProfessionalPractitionerRoleTelephoneNumber]?) {
        self.emailAddresses = emailAddresses
        self.fhirVersion = fhirVersion
        self.id = id
        self.location = location
        self.organization = organization
        self.practitioner = practitioner
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.speciality = speciality
        self.telephoneNumbers = telephoneNumbers
    }
}

// MARK: NlCoreHealthProfessionalPractitionerRole convenience initializers and mutators

public extension NlCoreHealthProfessionalPractitionerRole {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCoreHealthProfessionalPractitionerRole.self, from: data)
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
        emailAddresses: [NlCoreHealthProfessionalPractitionerRoleEmailAddress]?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        location: [MgoReference]?? = nil,
        organization: MgoReference?? = nil,
        practitioner: MgoReference?? = nil,
        profile: NlCoreHealthProfessionalPractitionerRoleProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        speciality: [MgoCodeableConcept]?? = nil,
        telephoneNumbers: [NlCoreHealthProfessionalPractitionerRoleTelephoneNumber]?? = nil
    ) -> NlCoreHealthProfessionalPractitionerRole {
        return NlCoreHealthProfessionalPractitionerRole(
            emailAddresses: emailAddresses ?? self.emailAddresses,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            location: location ?? self.location,
            organization: organization ?? self.organization,
            practitioner: practitioner ?? self.practitioner,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            speciality: speciality ?? self.speciality,
            telephoneNumbers: telephoneNumbers ?? self.telephoneNumbers
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
