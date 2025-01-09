// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCorePatient = try NlCorePatient(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCorePatient
public struct NlCorePatient: Codable, Hashable, Sendable {
    public let active: Bool?
    public let address: [NlCoreAddress]?
    public let birthDate: String?
    public let communication: [Communication]?
    public let contact: [Contact]?
    public let deceased: Bool?
    public let deceasedDateTime: String?
    public let fhirVersion: FhirVersionR3
    public let gender: Gender?
    public let generalPractitioner: [MgoReference]?
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let link: [Link]?
    public let managingOrganization: MgoReference?
    public let maritalStatus: MgoCodeableConcept?
    public let multipleBirth: Bool?
    public let multipleBirthInteger: Double?
    public let name: [NlCoreHumanname]?
    public let photo: [Attachment]?
    public let profile: NlCorePatientProfile
    public let referenceID: String
    public let resourceType: String?
    public let telecom: [NlCoreContactpoint]?

    public enum CodingKeys: String, CodingKey {
        case active, address, birthDate, communication, contact, deceased, deceasedDateTime, fhirVersion, gender, generalPractitioner, id, identifier, link, managingOrganization, maritalStatus, multipleBirth, multipleBirthInteger, name, photo, profile
        case referenceID = "referenceId"
        case resourceType, telecom
    }

    public init(active: Bool?, address: [NlCoreAddress]?, birthDate: String?, communication: [Communication]?, contact: [Contact]?, deceased: Bool?, deceasedDateTime: String?, fhirVersion: FhirVersionR3, gender: Gender?, generalPractitioner: [MgoReference]?, id: String?, identifier: [MgoIdentifier]?, link: [Link]?, managingOrganization: MgoReference?, maritalStatus: MgoCodeableConcept?, multipleBirth: Bool?, multipleBirthInteger: Double?, name: [NlCoreHumanname]?, photo: [Attachment]?, profile: NlCorePatientProfile, referenceID: String, resourceType: String?, telecom: [NlCoreContactpoint]?) {
        self.active = active
        self.address = address
        self.birthDate = birthDate
        self.communication = communication
        self.contact = contact
        self.deceased = deceased
        self.deceasedDateTime = deceasedDateTime
        self.fhirVersion = fhirVersion
        self.gender = gender
        self.generalPractitioner = generalPractitioner
        self.id = id
        self.identifier = identifier
        self.link = link
        self.managingOrganization = managingOrganization
        self.maritalStatus = maritalStatus
        self.multipleBirth = multipleBirth
        self.multipleBirthInteger = multipleBirthInteger
        self.name = name
        self.photo = photo
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.telecom = telecom
    }
}

// MARK: NlCorePatient convenience initializers and mutators

public extension NlCorePatient {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCorePatient.self, from: data)
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
        active: Bool?? = nil,
        address: [NlCoreAddress]?? = nil,
        birthDate: String?? = nil,
        communication: [Communication]?? = nil,
        contact: [Contact]?? = nil,
        deceased: Bool?? = nil,
        deceasedDateTime: String?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        gender: Gender?? = nil,
        generalPractitioner: [MgoReference]?? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        link: [Link]?? = nil,
        managingOrganization: MgoReference?? = nil,
        maritalStatus: MgoCodeableConcept?? = nil,
        multipleBirth: Bool?? = nil,
        multipleBirthInteger: Double?? = nil,
        name: [NlCoreHumanname]?? = nil,
        photo: [Attachment]?? = nil,
        profile: NlCorePatientProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        telecom: [NlCoreContactpoint]?? = nil
    ) -> NlCorePatient {
        return NlCorePatient(
            active: active ?? self.active,
            address: address ?? self.address,
            birthDate: birthDate ?? self.birthDate,
            communication: communication ?? self.communication,
            contact: contact ?? self.contact,
            deceased: deceased ?? self.deceased,
            deceasedDateTime: deceasedDateTime ?? self.deceasedDateTime,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            gender: gender ?? self.gender,
            generalPractitioner: generalPractitioner ?? self.generalPractitioner,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            link: link ?? self.link,
            managingOrganization: managingOrganization ?? self.managingOrganization,
            maritalStatus: maritalStatus ?? self.maritalStatus,
            multipleBirth: multipleBirth ?? self.multipleBirth,
            multipleBirthInteger: multipleBirthInteger ?? self.multipleBirthInteger,
            name: name ?? self.name,
            photo: photo ?? self.photo,
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
