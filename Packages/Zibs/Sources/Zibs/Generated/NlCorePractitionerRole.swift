// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCorePractitionerRole = try NlCorePractitionerRole(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCorePractitionerRole
public struct NlCorePractitionerRole: Codable, Hashable, Sendable {
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let organization: MgoReference?
    public let profile: NlCorePractitionerRoleProfile
    public let referenceID: String
    public let resourceType: String?
    public let specialty: [MgoCodeableConcept]?
    public let telecom: [NlCoreContactpoint]?

    public enum CodingKeys: String, CodingKey {
        case fhirVersion, id, identifier, organization, profile
        case referenceID = "referenceId"
        case resourceType, specialty, telecom
    }

    public init(fhirVersion: FhirVersionR3, id: String?, identifier: [MgoIdentifier]?, organization: MgoReference?, profile: NlCorePractitionerRoleProfile, referenceID: String, resourceType: String?, specialty: [MgoCodeableConcept]?, telecom: [NlCoreContactpoint]?) {
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.organization = organization
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.specialty = specialty
        self.telecom = telecom
    }
}

// MARK: NlCorePractitionerRole convenience initializers and mutators

public extension NlCorePractitionerRole {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCorePractitionerRole.self, from: data)
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
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        organization: MgoReference?? = nil,
        profile: NlCorePractitionerRoleProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        specialty: [MgoCodeableConcept]?? = nil,
        telecom: [NlCoreContactpoint]?? = nil
    ) -> NlCorePractitionerRole {
        return NlCorePractitionerRole(
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            organization: organization ?? self.organization,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            specialty: specialty ?? self.specialty,
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
