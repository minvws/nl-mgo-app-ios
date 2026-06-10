// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCoreHealthProfessionalPractitioner = try R4NlCoreHealthProfessionalPractitioner(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCoreHealthProfessionalPractitioner
public struct R4NlCoreHealthProfessionalPractitioner: Codable, Hashable, Sendable {
    public let address: [R4NlCoreHealthProfessionalPractitionerAddress]?
    public let fhirVersion: R4BBSDocumentReferenceFhirVersion
    public let gender: MgoCodeOfString?
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let name: [R4NlCoreHealthProfessionalPractitionerName]?
    public let profile: R4NlCoreHealthProfessionalPractitionerProfile
    public let referenceID, resourceType: String
    public let telecom: R4NlCoreContactInformation

    public enum CodingKeys: String, CodingKey {
        case address, fhirVersion, gender, id, identifier, name, profile
        case referenceID = "referenceId"
        case resourceType, telecom
    }

    public init(address: [R4NlCoreHealthProfessionalPractitionerAddress]?, fhirVersion: R4BBSDocumentReferenceFhirVersion, gender: MgoCodeOfString?, id: String?, identifier: [MgoIdentifier]?, name: [R4NlCoreHealthProfessionalPractitionerName]?, profile: R4NlCoreHealthProfessionalPractitionerProfile, referenceID: String, resourceType: String, telecom: R4NlCoreContactInformation) {
        self.address = address
        self.fhirVersion = fhirVersion
        self.gender = gender
        self.id = id
        self.identifier = identifier
        self.name = name
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.telecom = telecom
    }
}

// MARK: R4NlCoreHealthProfessionalPractitioner convenience initializers and mutators

public extension R4NlCoreHealthProfessionalPractitioner {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCoreHealthProfessionalPractitioner.self, from: data)
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
        address: [R4NlCoreHealthProfessionalPractitionerAddress]?? = nil,
        fhirVersion: R4BBSDocumentReferenceFhirVersion? = nil,
        gender: MgoCodeOfString?? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        name: [R4NlCoreHealthProfessionalPractitionerName]?? = nil,
        profile: R4NlCoreHealthProfessionalPractitionerProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        telecom: R4NlCoreContactInformation? = nil
    ) -> R4NlCoreHealthProfessionalPractitioner {
        return R4NlCoreHealthProfessionalPractitioner(
            address: address ?? self.address,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            gender: gender ?? self.gender,
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
