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
    public let emailAddresses: [R4NlCoreContactInformationEmailAddresses]?
    public let fhirVersion: FhirVersionR4
    public let id: String?
    public let location: [MgoReference]?
    public let organization, practitioner: MgoReference?
    public let profile: R4NlCoreHealthProfessionalPractitionerRoleProfile
    public let referenceID: String
    public let resourceType: String?
    public let speciality: [MgoCodeableConcept]?
    public let telephoneNumbers: [R4NlCoreContactInformationTelephoneNumbers]?

    public enum CodingKeys: String, CodingKey {
        case emailAddresses, fhirVersion, id, location, organization, practitioner, profile
        case referenceID = "referenceId"
        case resourceType, speciality, telephoneNumbers
    }

    public init(emailAddresses: [R4NlCoreContactInformationEmailAddresses]?, fhirVersion: FhirVersionR4, id: String?, location: [MgoReference]?, organization: MgoReference?, practitioner: MgoReference?, profile: R4NlCoreHealthProfessionalPractitionerRoleProfile, referenceID: String, resourceType: String?, speciality: [MgoCodeableConcept]?, telephoneNumbers: [R4NlCoreContactInformationTelephoneNumbers]?) {
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
        emailAddresses: [R4NlCoreContactInformationEmailAddresses]?? = nil,
        fhirVersion: FhirVersionR4? = nil,
        id: String?? = nil,
        location: [MgoReference]?? = nil,
        organization: MgoReference?? = nil,
        practitioner: MgoReference?? = nil,
        profile: R4NlCoreHealthProfessionalPractitionerRoleProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        speciality: [MgoCodeableConcept]?? = nil,
        telephoneNumbers: [R4NlCoreContactInformationTelephoneNumbers]?? = nil
    ) -> R4NlCoreHealthProfessionalPractitionerRole {
        return R4NlCoreHealthProfessionalPractitionerRole(
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
