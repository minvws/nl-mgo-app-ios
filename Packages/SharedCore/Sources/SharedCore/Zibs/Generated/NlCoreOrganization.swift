// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCoreOrganization = try NlCoreOrganization(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCoreOrganization
public struct NlCoreOrganization: Codable, Hashable, Sendable {
    public let address: [NlCoreOrganizationAddress]?
    public let alias: [MgoString]?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let name: MgoString?
    public let profile: NlCoreOrganizationProfile
    public let referenceID, resourceType: String
    public let telecom: [NlCoreOrganizationTelecom]?
    public let type: NlCoreOrganizationType

    public enum CodingKeys: String, CodingKey {
        case address, alias, fhirVersion, id, identifier, name, profile
        case referenceID = "referenceId"
        case resourceType, telecom, type
    }

    public init(address: [NlCoreOrganizationAddress]?, alias: [MgoString]?, fhirVersion: FhirVersionR3, id: String?, identifier: [MgoIdentifier]?, name: MgoString?, profile: NlCoreOrganizationProfile, referenceID: String, resourceType: String, telecom: [NlCoreOrganizationTelecom]?, type: NlCoreOrganizationType) {
        self.address = address
        self.alias = alias
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.name = name
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.telecom = telecom
        self.type = type
    }
}

// MARK: NlCoreOrganization convenience initializers and mutators

public extension NlCoreOrganization {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCoreOrganization.self, from: data)
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
        address: [NlCoreOrganizationAddress]?? = nil,
        alias: [MgoString]?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        name: MgoString?? = nil,
        profile: NlCoreOrganizationProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        telecom: [NlCoreOrganizationTelecom]?? = nil,
        type: NlCoreOrganizationType? = nil
    ) -> NlCoreOrganization {
        return NlCoreOrganization(
            address: address ?? self.address,
            alias: alias ?? self.alias,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            name: name ?? self.name,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            telecom: telecom ?? self.telecom,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
