// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCorePatientContact = try R4NlCorePatientContact(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCorePatientContact
public struct R4NlCorePatientContact: Codable, Hashable, Sendable {
    public let profile: ContactProfile
    public let address: R4NlCoreAddressInformation
    public let name: NameClass
    public let relationship: FluffyRelationship
    public let telecom: R4NlCoreContactInformation

    public enum CodingKeys: String, CodingKey {
        case profile = "_profile"
        case address, name, relationship, telecom
    }

    public init(profile: ContactProfile, address: R4NlCoreAddressInformation, name: NameClass, relationship: FluffyRelationship, telecom: R4NlCoreContactInformation) {
        self.profile = profile
        self.address = address
        self.name = name
        self.relationship = relationship
        self.telecom = telecom
    }
}

// MARK: R4NlCorePatientContact convenience initializers and mutators

public extension R4NlCorePatientContact {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCorePatientContact.self, from: data)
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
        profile: ContactProfile? = nil,
        address: R4NlCoreAddressInformation? = nil,
        name: NameClass? = nil,
        relationship: FluffyRelationship? = nil,
        telecom: R4NlCoreContactInformation? = nil
    ) -> R4NlCorePatientContact {
        return R4NlCorePatientContact(
            profile: profile ?? self.profile,
            address: address ?? self.address,
            name: name ?? self.name,
            relationship: relationship ?? self.relationship,
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
