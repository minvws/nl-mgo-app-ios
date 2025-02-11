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
    public let address: [NlCoreAddress]?
    public let departmentSpecialty: [MgoCodeableConcept]?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let name: String?
    public let organizationType: [MgoCodeableConcept]?
    public let profile: NlCoreOrganizationProfile
    public let referenceID: String
    public let resourceType: String?
    public let telecom: [NlCoreContactpoint]?

    public enum CodingKeys: String, CodingKey {
        case address, departmentSpecialty, fhirVersion, id, identifier, name, organizationType, profile
        case referenceID = "referenceId"
        case resourceType, telecom
    }

    public init(address: [NlCoreAddress]?, departmentSpecialty: [MgoCodeableConcept]?, fhirVersion: FhirVersionR3, id: String?, identifier: [MgoIdentifier]?, name: String?, organizationType: [MgoCodeableConcept]?, profile: NlCoreOrganizationProfile, referenceID: String, resourceType: String?, telecom: [NlCoreContactpoint]?) {
        self.address = address
        self.departmentSpecialty = departmentSpecialty
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.name = name
        self.organizationType = organizationType
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.telecom = telecom
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
        address: [NlCoreAddress]?? = nil,
        departmentSpecialty: [MgoCodeableConcept]?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        name: String?? = nil,
        organizationType: [MgoCodeableConcept]?? = nil,
        profile: NlCoreOrganizationProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        telecom: [NlCoreContactpoint]?? = nil
    ) -> NlCoreOrganization {
        return NlCoreOrganization(
            address: address ?? self.address,
            departmentSpecialty: departmentSpecialty ?? self.departmentSpecialty,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            name: name ?? self.name,
            organizationType: organizationType ?? self.organizationType,
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
