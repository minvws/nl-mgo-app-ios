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
    public let address: [R4NlCorePatientAddress]?
    public let birthDate: PrimitiveValueTypeOfDateDateString?
    public let communication: [R4NlCorePatientCommunication]?
    public let contact: [R4NlCorePatientContact]?
    public let deceasedBoolean: PrimitiveValueTypeOfBooleanBoolean?
    public let deceasedDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?
    public let fhirVersion: R4NlCoreHealthcareProviderFhirVersion
    public let gender: R4NlCorePatientGender
    public let id: String?
    public let identifier: R4NlCorePatientIdentifier
    public let maritalStatus: MgoCodeableConcept?
    public let multipleBirthBoolean: PrimitiveValueTypeOfBooleanBoolean?
    public let multipleBirthInteger: PrimitiveValueTypeOfIntegerNumber?
    public let name: [R4NlCorePatientName]?
    public let nationality: [ExtensionValueOfStructure0_08903279847583878]
    public let profile: R4NlCorePatientProfile
    public let referenceID, resourceType: String
    public let telecom: R4NlCoreContactInformation

    public enum CodingKeys: String, CodingKey {
        case address, birthDate, communication, contact, deceasedBoolean, deceasedDateTime, fhirVersion, gender, id, identifier, maritalStatus, multipleBirthBoolean, multipleBirthInteger, name, nationality, profile
        case referenceID = "referenceId"
        case resourceType, telecom
    }

    public init(address: [R4NlCorePatientAddress]?, birthDate: PrimitiveValueTypeOfDateDateString?, communication: [R4NlCorePatientCommunication]?, contact: [R4NlCorePatientContact]?, deceasedBoolean: PrimitiveValueTypeOfBooleanBoolean?, deceasedDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?, fhirVersion: R4NlCoreHealthcareProviderFhirVersion, gender: R4NlCorePatientGender, id: String?, identifier: R4NlCorePatientIdentifier, maritalStatus: MgoCodeableConcept?, multipleBirthBoolean: PrimitiveValueTypeOfBooleanBoolean?, multipleBirthInteger: PrimitiveValueTypeOfIntegerNumber?, name: [R4NlCorePatientName]?, nationality: [ExtensionValueOfStructure0_08903279847583878], profile: R4NlCorePatientProfile, referenceID: String, resourceType: String, telecom: R4NlCoreContactInformation) {
        self.address = address
        self.birthDate = birthDate
        self.communication = communication
        self.contact = contact
        self.deceasedBoolean = deceasedBoolean
        self.deceasedDateTime = deceasedDateTime
        self.fhirVersion = fhirVersion
        self.gender = gender
        self.id = id
        self.identifier = identifier
        self.maritalStatus = maritalStatus
        self.multipleBirthBoolean = multipleBirthBoolean
        self.multipleBirthInteger = multipleBirthInteger
        self.name = name
        self.nationality = nationality
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.telecom = telecom
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
        address: [R4NlCorePatientAddress]?? = nil,
        birthDate: PrimitiveValueTypeOfDateDateString?? = nil,
        communication: [R4NlCorePatientCommunication]?? = nil,
        contact: [R4NlCorePatientContact]?? = nil,
        deceasedBoolean: PrimitiveValueTypeOfBooleanBoolean?? = nil,
        deceasedDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?? = nil,
        fhirVersion: R4NlCoreHealthcareProviderFhirVersion? = nil,
        gender: R4NlCorePatientGender? = nil,
        id: String?? = nil,
        identifier: R4NlCorePatientIdentifier? = nil,
        maritalStatus: MgoCodeableConcept?? = nil,
        multipleBirthBoolean: PrimitiveValueTypeOfBooleanBoolean?? = nil,
        multipleBirthInteger: PrimitiveValueTypeOfIntegerNumber?? = nil,
        name: [R4NlCorePatientName]?? = nil,
        nationality: [ExtensionValueOfStructure0_08903279847583878]? = nil,
        profile: R4NlCorePatientProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        telecom: R4NlCoreContactInformation? = nil
    ) -> R4NlCorePatient {
        return R4NlCorePatient(
            address: address ?? self.address,
            birthDate: birthDate ?? self.birthDate,
            communication: communication ?? self.communication,
            contact: contact ?? self.contact,
            deceasedBoolean: deceasedBoolean ?? self.deceasedBoolean,
            deceasedDateTime: deceasedDateTime ?? self.deceasedDateTime,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            gender: gender ?? self.gender,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            maritalStatus: maritalStatus ?? self.maritalStatus,
            multipleBirthBoolean: multipleBirthBoolean ?? self.multipleBirthBoolean,
            multipleBirthInteger: multipleBirthInteger ?? self.multipleBirthInteger,
            name: name ?? self.name,
            nationality: nationality ?? self.nationality,
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
