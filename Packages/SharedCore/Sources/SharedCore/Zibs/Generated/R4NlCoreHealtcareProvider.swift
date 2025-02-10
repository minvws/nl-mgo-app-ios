// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCoreHealtcareProvider = try R4NlCoreHealtcareProvider(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCoreHealtcareProvider
public struct R4NlCoreHealtcareProvider: Codable, Hashable, Sendable {
    public let address: R4NlCoreAddressInformation
    public let emailAddresses: [R4NlCoreContactInformationEmailAddresses]?
    public let fhirVersion: FhirVersionR4
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let managingOrganization: MgoReference?
    public let name: String?
    public let profile: R4NlCoreHealtcareProviderProfile
    public let referenceID: String
    public let resourceType: String?
    public let telephoneNumbers: [R4NlCoreContactInformationTelephoneNumbers]?

    public enum CodingKeys: String, CodingKey {
        case address, emailAddresses, fhirVersion, id, identifier, managingOrganization, name, profile
        case referenceID = "referenceId"
        case resourceType, telephoneNumbers
    }

    public init(address: R4NlCoreAddressInformation, emailAddresses: [R4NlCoreContactInformationEmailAddresses]?, fhirVersion: FhirVersionR4, id: String?, identifier: [MgoIdentifier]?, managingOrganization: MgoReference?, name: String?, profile: R4NlCoreHealtcareProviderProfile, referenceID: String, resourceType: String?, telephoneNumbers: [R4NlCoreContactInformationTelephoneNumbers]?) {
        self.address = address
        self.emailAddresses = emailAddresses
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.managingOrganization = managingOrganization
        self.name = name
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.telephoneNumbers = telephoneNumbers
    }
}

// MARK: R4NlCoreHealtcareProvider convenience initializers and mutators

public extension R4NlCoreHealtcareProvider {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCoreHealtcareProvider.self, from: data)
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
        address: R4NlCoreAddressInformation? = nil,
        emailAddresses: [R4NlCoreContactInformationEmailAddresses]?? = nil,
        fhirVersion: FhirVersionR4? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        managingOrganization: MgoReference?? = nil,
        name: String?? = nil,
        profile: R4NlCoreHealtcareProviderProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        telephoneNumbers: [R4NlCoreContactInformationTelephoneNumbers]?? = nil
    ) -> R4NlCoreHealtcareProvider {
        return R4NlCoreHealtcareProvider(
            address: address ?? self.address,
            emailAddresses: emailAddresses ?? self.emailAddresses,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            managingOrganization: managingOrganization ?? self.managingOrganization,
            name: name ?? self.name,
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
