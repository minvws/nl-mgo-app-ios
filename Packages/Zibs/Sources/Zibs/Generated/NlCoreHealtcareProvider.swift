// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCoreHealtcareProvider = try NlCoreHealtcareProvider(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCoreHealtcareProvider
public struct NlCoreHealtcareProvider: Codable, Hashable, Sendable {
    public let address: NlCoreHealtcareProviderAddress
    public let emailAddresses: [NlCoreHealtcareProviderEmailAddress]?
    public let fhirVersion: FhirVersionR4
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let managingOrganization: MgoReference?
    public let name: String?
    public let profile: NlCoreHealtcareProviderProfile
    public let referenceID: String
    public let resourceType: String?
    public let telephoneNumbers: [NlCoreHealtcareProviderTelephoneNumber]?

    public enum CodingKeys: String, CodingKey {
        case address, emailAddresses, fhirVersion, id, identifier, managingOrganization, name, profile
        case referenceID = "referenceId"
        case resourceType, telephoneNumbers
    }

    public init(address: NlCoreHealtcareProviderAddress, emailAddresses: [NlCoreHealtcareProviderEmailAddress]?, fhirVersion: FhirVersionR4, id: String?, identifier: [MgoIdentifier]?, managingOrganization: MgoReference?, name: String?, profile: NlCoreHealtcareProviderProfile, referenceID: String, resourceType: String?, telephoneNumbers: [NlCoreHealtcareProviderTelephoneNumber]?) {
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

// MARK: NlCoreHealtcareProvider convenience initializers and mutators

public extension NlCoreHealtcareProvider {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCoreHealtcareProvider.self, from: data)
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
        address: NlCoreHealtcareProviderAddress? = nil,
        emailAddresses: [NlCoreHealtcareProviderEmailAddress]?? = nil,
        fhirVersion: FhirVersionR4? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        managingOrganization: MgoReference?? = nil,
        name: String?? = nil,
        profile: NlCoreHealtcareProviderProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        telephoneNumbers: [NlCoreHealtcareProviderTelephoneNumber]?? = nil
    ) -> NlCoreHealtcareProvider {
        return NlCoreHealtcareProvider(
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
