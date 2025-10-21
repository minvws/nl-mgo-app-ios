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
    public let address: [NlCorePatientAddress]?
    public let birthDate: PrimitiveValueTypeOfDateDateString?
    public let communication: [NlCorePatientCommunication]?
    public let contact: [NlCorePatientContact]?
    public let deceasedBoolean: PrimitiveValueTypeOfBooleanBoolean?
    public let deceasedDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?
    public let fhirVersion: NlCoreObservationFhirVersion
    public let gender: NlCorePatientGender
    public let generalPractitioner: MgoReference?
    public let id: String?
    public let identifier: NlCorePatientIdentifier
    public let legalStatus, lifeStance: [ExtensionValueOfMgoCodeableConcept]
    public let maritalStatus: MgoCodeableConcept?
    public let multipleBirthBoolean: PrimitiveValueTypeOfBooleanBoolean?
    public let multipleBirthInteger: PrimitiveValueTypeOfIntegerNumber?
    public let name: [NlCorePatientName]?
    public let nationality: [ExtensionValueOfStructure0_48277522201318557]
    public let preferredPharmacy: ExtensionValueOfMgoReference?
    public let profile: NlCorePatientProfile
    public let referenceID, resourceType: String
    public let telecom: [NlCorePatientTelecom]?

    public enum CodingKeys: String, CodingKey {
        case address, birthDate, communication, contact, deceasedBoolean, deceasedDateTime, fhirVersion, gender, generalPractitioner, id, identifier, legalStatus, lifeStance, maritalStatus, multipleBirthBoolean, multipleBirthInteger, name, nationality, preferredPharmacy, profile
        case referenceID = "referenceId"
        case resourceType, telecom
    }

    public init(address: [NlCorePatientAddress]?, birthDate: PrimitiveValueTypeOfDateDateString?, communication: [NlCorePatientCommunication]?, contact: [NlCorePatientContact]?, deceasedBoolean: PrimitiveValueTypeOfBooleanBoolean?, deceasedDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?, fhirVersion: NlCoreObservationFhirVersion, gender: NlCorePatientGender, generalPractitioner: MgoReference?, id: String?, identifier: NlCorePatientIdentifier, legalStatus: [ExtensionValueOfMgoCodeableConcept], lifeStance: [ExtensionValueOfMgoCodeableConcept], maritalStatus: MgoCodeableConcept?, multipleBirthBoolean: PrimitiveValueTypeOfBooleanBoolean?, multipleBirthInteger: PrimitiveValueTypeOfIntegerNumber?, name: [NlCorePatientName]?, nationality: [ExtensionValueOfStructure0_48277522201318557], preferredPharmacy: ExtensionValueOfMgoReference?, profile: NlCorePatientProfile, referenceID: String, resourceType: String, telecom: [NlCorePatientTelecom]?) {
        self.address = address
        self.birthDate = birthDate
        self.communication = communication
        self.contact = contact
        self.deceasedBoolean = deceasedBoolean
        self.deceasedDateTime = deceasedDateTime
        self.fhirVersion = fhirVersion
        self.gender = gender
        self.generalPractitioner = generalPractitioner
        self.id = id
        self.identifier = identifier
        self.legalStatus = legalStatus
        self.lifeStance = lifeStance
        self.maritalStatus = maritalStatus
        self.multipleBirthBoolean = multipleBirthBoolean
        self.multipleBirthInteger = multipleBirthInteger
        self.name = name
        self.nationality = nationality
        self.preferredPharmacy = preferredPharmacy
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
        address: [NlCorePatientAddress]?? = nil,
        birthDate: PrimitiveValueTypeOfDateDateString?? = nil,
        communication: [NlCorePatientCommunication]?? = nil,
        contact: [NlCorePatientContact]?? = nil,
        deceasedBoolean: PrimitiveValueTypeOfBooleanBoolean?? = nil,
        deceasedDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?? = nil,
        fhirVersion: NlCoreObservationFhirVersion? = nil,
        gender: NlCorePatientGender? = nil,
        generalPractitioner: MgoReference?? = nil,
        id: String?? = nil,
        identifier: NlCorePatientIdentifier? = nil,
        legalStatus: [ExtensionValueOfMgoCodeableConcept]? = nil,
        lifeStance: [ExtensionValueOfMgoCodeableConcept]? = nil,
        maritalStatus: MgoCodeableConcept?? = nil,
        multipleBirthBoolean: PrimitiveValueTypeOfBooleanBoolean?? = nil,
        multipleBirthInteger: PrimitiveValueTypeOfIntegerNumber?? = nil,
        name: [NlCorePatientName]?? = nil,
        nationality: [ExtensionValueOfStructure0_48277522201318557]? = nil,
        preferredPharmacy: ExtensionValueOfMgoReference?? = nil,
        profile: NlCorePatientProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        telecom: [NlCorePatientTelecom]?? = nil
    ) -> NlCorePatient {
        return NlCorePatient(
            address: address ?? self.address,
            birthDate: birthDate ?? self.birthDate,
            communication: communication ?? self.communication,
            contact: contact ?? self.contact,
            deceasedBoolean: deceasedBoolean ?? self.deceasedBoolean,
            deceasedDateTime: deceasedDateTime ?? self.deceasedDateTime,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            gender: gender ?? self.gender,
            generalPractitioner: generalPractitioner ?? self.generalPractitioner,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            legalStatus: legalStatus ?? self.legalStatus,
            lifeStance: lifeStance ?? self.lifeStance,
            maritalStatus: maritalStatus ?? self.maritalStatus,
            multipleBirthBoolean: multipleBirthBoolean ?? self.multipleBirthBoolean,
            multipleBirthInteger: multipleBirthInteger ?? self.multipleBirthInteger,
            name: name ?? self.name,
            nationality: nationality ?? self.nationality,
            preferredPharmacy: preferredPharmacy ?? self.preferredPharmacy,
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
