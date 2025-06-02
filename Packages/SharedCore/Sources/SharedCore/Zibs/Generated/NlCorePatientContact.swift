// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCorePatientContact = try NlCorePatientContact(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCorePatientContact
public struct NlCorePatientContact: Codable, Hashable, Sendable {
    public let address: NlCoreAddress
    public let name: NlCoreHumanname
    public let relationship: PurpleRelationship
    public let telecom: [PurpleTelecom]?

    public init(address: NlCoreAddress, name: NlCoreHumanname, relationship: PurpleRelationship, telecom: [PurpleTelecom]?) {
        self.address = address
        self.name = name
        self.relationship = relationship
        self.telecom = telecom
    }
}

// MARK: NlCorePatientContact convenience initializers and mutators

public extension NlCorePatientContact {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCorePatientContact.self, from: data)
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
        address: NlCoreAddress? = nil,
        name: NlCoreHumanname? = nil,
        relationship: PurpleRelationship? = nil,
        telecom: [PurpleTelecom]?? = nil
    ) -> NlCorePatientContact {
        return NlCorePatientContact(
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
