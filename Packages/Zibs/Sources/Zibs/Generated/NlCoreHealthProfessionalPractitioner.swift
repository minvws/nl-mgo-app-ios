// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCoreHealthProfessionalPractitioner = try NlCoreHealthProfessionalPractitioner(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCoreHealthProfessionalPractitioner
public struct NlCoreHealthProfessionalPractitioner: Codable, Hashable, Sendable {
    public let address: [NlCoreHealthProfessionalPractitionerAddress]?
    public let birthDate: String?
    public let communication: [MgoCodeableConcept]?
    public let emailAddresses: [EmailAddress]?
    public let fhirVersion: FhirVersionR4
    public let gender, id: String?
    public let identifier: [MgoIdentifier]?
    public let name: [NlCoreHealthProfessionalPractitionerName]?
    public let profile: NlCoreHealthProfessionalPractitionerProfile
    public let qualification: [Qualification]?
    public let referenceID: String
    public let resourceType: String?
    public let telephoneNumbers: [TelephoneNumber]?

    public enum CodingKeys: String, CodingKey {
        case address, birthDate, communication, emailAddresses, fhirVersion, gender, id, identifier, name, profile, qualification
        case referenceID = "referenceId"
        case resourceType, telephoneNumbers
    }

    public init(address: [NlCoreHealthProfessionalPractitionerAddress]?, birthDate: String?, communication: [MgoCodeableConcept]?, emailAddresses: [EmailAddress]?, fhirVersion: FhirVersionR4, gender: String?, id: String?, identifier: [MgoIdentifier]?, name: [NlCoreHealthProfessionalPractitionerName]?, profile: NlCoreHealthProfessionalPractitionerProfile, qualification: [Qualification]?, referenceID: String, resourceType: String?, telephoneNumbers: [TelephoneNumber]?) {
        self.address = address
        self.birthDate = birthDate
        self.communication = communication
        self.emailAddresses = emailAddresses
        self.fhirVersion = fhirVersion
        self.gender = gender
        self.id = id
        self.identifier = identifier
        self.name = name
        self.profile = profile
        self.qualification = qualification
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.telephoneNumbers = telephoneNumbers
    }
}

// MARK: NlCoreHealthProfessionalPractitioner convenience initializers and mutators

public extension NlCoreHealthProfessionalPractitioner {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCoreHealthProfessionalPractitioner.self, from: data)
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
        address: [NlCoreHealthProfessionalPractitionerAddress]?? = nil,
        birthDate: String?? = nil,
        communication: [MgoCodeableConcept]?? = nil,
        emailAddresses: [EmailAddress]?? = nil,
        fhirVersion: FhirVersionR4? = nil,
        gender: String?? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        name: [NlCoreHealthProfessionalPractitionerName]?? = nil,
        profile: NlCoreHealthProfessionalPractitionerProfile? = nil,
        qualification: [Qualification]?? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        telephoneNumbers: [TelephoneNumber]?? = nil
    ) -> NlCoreHealthProfessionalPractitioner {
        return NlCoreHealthProfessionalPractitioner(
            address: address ?? self.address,
            birthDate: birthDate ?? self.birthDate,
            communication: communication ?? self.communication,
            emailAddresses: emailAddresses ?? self.emailAddresses,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            gender: gender ?? self.gender,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            name: name ?? self.name,
            profile: profile ?? self.profile,
            qualification: qualification ?? self.qualification,
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
