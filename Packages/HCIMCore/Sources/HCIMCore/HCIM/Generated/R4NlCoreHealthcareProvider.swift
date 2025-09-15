// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCoreHealthcareProvider = try R4NlCoreHealthcareProvider(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCoreHealthcareProvider
public struct R4NlCoreHealthcareProvider: Codable, Hashable, Sendable {
    public let address: R4NlCoreAddressInformation
    public let fhirVersion: R4NlCoreHealthcareProviderFhirVersion
    public let id: String?
    public let managingOrganization: MgoReference?
    public let name: PrimitiveValueTypeOfStringString?
    public let profile: R4NlCoreHealthcareProviderProfile
    public let referenceID, resourceType: String
    public let telecom: R4NlCoreContactInformation

    public enum CodingKeys: String, CodingKey {
        case address, fhirVersion, id, managingOrganization, name, profile
        case referenceID = "referenceId"
        case resourceType, telecom
    }

    public init(address: R4NlCoreAddressInformation, fhirVersion: R4NlCoreHealthcareProviderFhirVersion, id: String?, managingOrganization: MgoReference?, name: PrimitiveValueTypeOfStringString?, profile: R4NlCoreHealthcareProviderProfile, referenceID: String, resourceType: String, telecom: R4NlCoreContactInformation) {
        self.address = address
        self.fhirVersion = fhirVersion
        self.id = id
        self.managingOrganization = managingOrganization
        self.name = name
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.telecom = telecom
    }
}

// MARK: R4NlCoreHealthcareProvider convenience initializers and mutators

public extension R4NlCoreHealthcareProvider {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCoreHealthcareProvider.self, from: data)
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
        fhirVersion: R4NlCoreHealthcareProviderFhirVersion? = nil,
        id: String?? = nil,
        managingOrganization: MgoReference?? = nil,
        name: PrimitiveValueTypeOfStringString?? = nil,
        profile: R4NlCoreHealthcareProviderProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        telecom: R4NlCoreContactInformation? = nil
    ) -> R4NlCoreHealthcareProvider {
        return R4NlCoreHealthcareProvider(
            address: address ?? self.address,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            managingOrganization: managingOrganization ?? self.managingOrganization,
            name: name ?? self.name,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
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
