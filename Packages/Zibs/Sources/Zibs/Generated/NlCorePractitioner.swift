// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCorePractitioner = try NlCorePractitioner(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCorePractitioner
public struct NlCorePractitioner: Codable, Hashable, Sendable {
    public let address: [NlCoreAddress]?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let name: [NlCoreHumanname]?
    public let profile: NlCorePractitionerProfile
    public let referenceID: String
    public let resourceType: String?
    public let telecom: [NlCoreContactpoint]?

    public enum CodingKeys: String, CodingKey {
        case address, fhirVersion, id, identifier, name, profile
        case referenceID = "referenceId"
        case resourceType, telecom
    }

    public init(address: [NlCoreAddress]?, fhirVersion: FhirVersionR3, id: String?, identifier: [MgoIdentifier]?, name: [NlCoreHumanname]?, profile: NlCorePractitionerProfile, referenceID: String, resourceType: String?, telecom: [NlCoreContactpoint]?) {
        self.address = address
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.name = name
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.telecom = telecom
    }
}

// MARK: NlCorePractitioner convenience initializers and mutators

public extension NlCorePractitioner {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCorePractitioner.self, from: data)
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
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        name: [NlCoreHumanname]?? = nil,
        profile: NlCorePractitionerProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        telecom: [NlCoreContactpoint]?? = nil
    ) -> NlCorePractitioner {
        return NlCorePractitioner(
            address: address ?? self.address,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
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
