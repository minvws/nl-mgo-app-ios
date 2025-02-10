// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let contact = try Contact(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - Contact
public struct Contact: Codable, Hashable, Sendable {
    public let address: NlCoreAddress
    public let gender: String?
    public let name: NlCoreHumanname
    public let organization: MgoReference?
    public let period: MgoPeriod?
    public let relationship: [MgoCodeableConcept]
    public let telecom: [NlCoreContactpoint]

    public init(address: NlCoreAddress, gender: String?, name: NlCoreHumanname, organization: MgoReference?, period: MgoPeriod?, relationship: [MgoCodeableConcept], telecom: [NlCoreContactpoint]) {
        self.address = address
        self.gender = gender
        self.name = name
        self.organization = organization
        self.period = period
        self.relationship = relationship
        self.telecom = telecom
    }
}

// MARK: Contact convenience initializers and mutators

public extension Contact {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Contact.self, from: data)
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
        gender: String?? = nil,
        name: NlCoreHumanname? = nil,
        organization: MgoReference?? = nil,
        period: MgoPeriod?? = nil,
        relationship: [MgoCodeableConcept]? = nil,
        telecom: [NlCoreContactpoint]? = nil
    ) -> Contact {
        return Contact(
            address: address ?? self.address,
            gender: gender ?? self.gender,
            name: name ?? self.name,
            organization: organization ?? self.organization,
            period: period ?? self.period,
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
