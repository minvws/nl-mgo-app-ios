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
    public let address: [R4NlCoreAddressInformation]?
    public let birthDate: String?
    public let communication: [MgoCodeableConcept]?
    public let emailAddresses: [R4NlCoreContactInformationEmailAddresses]?
    public let fhirVersion: FhirVersionR4
    public let gender: Gender?
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let name: [NameElement]?
    public let profile: R4NlCoreHealthProfessionalPractitionerProfile
    public let qualification: [Qualification]?
    public let referenceID: String
    public let resourceType: String?
    public let telephoneNumbers: [R4NlCoreContactInformationTelephoneNumbers]?

    public enum CodingKeys: String, CodingKey {
        case address, birthDate, communication, emailAddresses, fhirVersion, gender, id, identifier, name, profile, qualification
        case referenceID = "referenceId"
        case resourceType, telephoneNumbers
    }

    public init(address: [R4NlCoreAddressInformation]?, birthDate: String?, communication: [MgoCodeableConcept]?, emailAddresses: [R4NlCoreContactInformationEmailAddresses]?, fhirVersion: FhirVersionR4, gender: Gender?, id: String?, identifier: [MgoIdentifier]?, name: [NameElement]?, profile: R4NlCoreHealthProfessionalPractitionerProfile, qualification: [Qualification]?, referenceID: String, resourceType: String?, telephoneNumbers: [R4NlCoreContactInformationTelephoneNumbers]?) {
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
        address: [R4NlCoreAddressInformation]?? = nil,
        birthDate: String?? = nil,
        communication: [MgoCodeableConcept]?? = nil,
        emailAddresses: [R4NlCoreContactInformationEmailAddresses]?? = nil,
        fhirVersion: FhirVersionR4? = nil,
        gender: Gender?? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        name: [NameElement]?? = nil,
        profile: R4NlCoreHealthProfessionalPractitionerProfile? = nil,
        qualification: [Qualification]?? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        telephoneNumbers: [R4NlCoreContactInformationTelephoneNumbers]?? = nil
    ) -> R4NlCoreHealthProfessionalPractitioner {
        return R4NlCoreHealthProfessionalPractitioner(
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
