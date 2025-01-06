// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCoreHealthcareProviderOrganization = try R4NlCoreHealthcareProviderOrganization(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCoreHealthcareProviderOrganization
public struct R4NlCoreHealthcareProviderOrganization: Codable, Hashable, Sendable {
    public let address: [R4NlCoreAddressInformation]?
    public let departmentSpecialty: [MgoCodeableConcept]?
    public let emailAddresses: [R4NlCoreContactInformationEmailAddresses]?
    public let fhirVersion: FhirVersionR4
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let name: String?
    public let organizationType: [MgoCodeableConcept]?
    public let profile: R4NlCoreHealthcareProviderOrganizationProfile
    public let referenceID: String
    public let resourceType: String?
    public let telephoneNumbers: [R4NlCoreContactInformationTelephoneNumbers]?

    public enum CodingKeys: String, CodingKey {
        case address, departmentSpecialty, emailAddresses, fhirVersion, id, identifier, name, organizationType, profile
        case referenceID = "referenceId"
        case resourceType, telephoneNumbers
    }

    public init(address: [R4NlCoreAddressInformation]?, departmentSpecialty: [MgoCodeableConcept]?, emailAddresses: [R4NlCoreContactInformationEmailAddresses]?, fhirVersion: FhirVersionR4, id: String?, identifier: [MgoIdentifier]?, name: String?, organizationType: [MgoCodeableConcept]?, profile: R4NlCoreHealthcareProviderOrganizationProfile, referenceID: String, resourceType: String?, telephoneNumbers: [R4NlCoreContactInformationTelephoneNumbers]?) {
        self.address = address
        self.departmentSpecialty = departmentSpecialty
        self.emailAddresses = emailAddresses
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.name = name
        self.organizationType = organizationType
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.telephoneNumbers = telephoneNumbers
    }
}

// MARK: R4NlCoreHealthcareProviderOrganization convenience initializers and mutators

public extension R4NlCoreHealthcareProviderOrganization {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCoreHealthcareProviderOrganization.self, from: data)
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
        address: [R4NlCoreAddressInformation]?? = nil,
        departmentSpecialty: [MgoCodeableConcept]?? = nil,
        emailAddresses: [R4NlCoreContactInformationEmailAddresses]?? = nil,
        fhirVersion: FhirVersionR4? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        name: String?? = nil,
        organizationType: [MgoCodeableConcept]?? = nil,
        profile: R4NlCoreHealthcareProviderOrganizationProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        telephoneNumbers: [R4NlCoreContactInformationTelephoneNumbers]?? = nil
    ) -> R4NlCoreHealthcareProviderOrganization {
        return R4NlCoreHealthcareProviderOrganization(
            address: address ?? self.address,
            departmentSpecialty: departmentSpecialty ?? self.departmentSpecialty,
            emailAddresses: emailAddresses ?? self.emailAddresses,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            name: name ?? self.name,
            organizationType: organizationType ?? self.organizationType,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
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
