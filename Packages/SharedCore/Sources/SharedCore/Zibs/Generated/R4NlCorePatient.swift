// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCorePatient = try R4NlCorePatient(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCorePatient
public struct R4NlCorePatient: Codable, Hashable, Sendable {
    public let address: [R4NlCoreAddressInformation]?
    public let birthDate: String?
    public let deceased: Bool?
    public let deceasedDateTime: String?
    public let fhirVersion: FhirVersionR4
    public let gender: Gender?
    public let generalPractitioner: [MgoReference]?
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let managingOrganization: MgoReference?
    public let maritalStatus: MgoCodeableConcept?
    public let multipleBirth: Bool?
    public let name: [NameElement]?
    public let profile: R4NlCorePatientProfile
    public let referenceID: String
    public let resourceType: String?

    public enum CodingKeys: String, CodingKey {
        case address, birthDate, deceased, deceasedDateTime, fhirVersion, gender, generalPractitioner, id, identifier, managingOrganization, maritalStatus, multipleBirth, name, profile
        case referenceID = "referenceId"
        case resourceType
    }

    public init(address: [R4NlCoreAddressInformation]?, birthDate: String?, deceased: Bool?, deceasedDateTime: String?, fhirVersion: FhirVersionR4, gender: Gender?, generalPractitioner: [MgoReference]?, id: String?, identifier: [MgoIdentifier]?, managingOrganization: MgoReference?, maritalStatus: MgoCodeableConcept?, multipleBirth: Bool?, name: [NameElement]?, profile: R4NlCorePatientProfile, referenceID: String, resourceType: String?) {
        self.address = address
        self.birthDate = birthDate
        self.deceased = deceased
        self.deceasedDateTime = deceasedDateTime
        self.fhirVersion = fhirVersion
        self.gender = gender
        self.generalPractitioner = generalPractitioner
        self.id = id
        self.identifier = identifier
        self.managingOrganization = managingOrganization
        self.maritalStatus = maritalStatus
        self.multipleBirth = multipleBirth
        self.name = name
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
    }
}

// MARK: R4NlCorePatient convenience initializers and mutators

public extension R4NlCorePatient {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCorePatient.self, from: data)
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
        deceased: Bool?? = nil,
        deceasedDateTime: String?? = nil,
        fhirVersion: FhirVersionR4? = nil,
        gender: Gender?? = nil,
        generalPractitioner: [MgoReference]?? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        managingOrganization: MgoReference?? = nil,
        maritalStatus: MgoCodeableConcept?? = nil,
        multipleBirth: Bool?? = nil,
        name: [NameElement]?? = nil,
        profile: R4NlCorePatientProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil
    ) -> R4NlCorePatient {
        return R4NlCorePatient(
            address: address ?? self.address,
            birthDate: birthDate ?? self.birthDate,
            deceased: deceased ?? self.deceased,
            deceasedDateTime: deceasedDateTime ?? self.deceasedDateTime,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            gender: gender ?? self.gender,
            generalPractitioner: generalPractitioner ?? self.generalPractitioner,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            managingOrganization: managingOrganization ?? self.managingOrganization,
            maritalStatus: maritalStatus ?? self.maritalStatus,
            multipleBirth: multipleBirth ?? self.multipleBirth,
            name: name ?? self.name,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
