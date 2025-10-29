// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCoreRelatedPerson = try NlCoreRelatedPerson(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCoreRelatedPerson
public struct NlCoreRelatedPerson: Codable, Hashable, Sendable {
    public let address: [NlCoreRelatedPersonAddress]?
    public let fhirVersion: NlCoreObservationFhirVersion
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let name: [NlCoreRelatedPersonName]?
    public let patient: MgoReference?
    public let period: MgoPeriod?
    public let profile: NlCoreRelatedPersonProfile
    public let referenceID: String
    public let relationship: MgoCodeableConcept?
    public let resourceType: String
    public let role: ExtensionValueOfMgoCodeableConcept?
    public let telecom: [NlCoreRelatedPersonTelecom]?

    public enum CodingKeys: String, CodingKey {
        case address, fhirVersion, id, identifier, name, patient, period, profile
        case referenceID = "referenceId"
        case relationship, resourceType, role, telecom
    }

    public init(address: [NlCoreRelatedPersonAddress]?, fhirVersion: NlCoreObservationFhirVersion, id: String?, identifier: [MgoIdentifier]?, name: [NlCoreRelatedPersonName]?, patient: MgoReference?, period: MgoPeriod?, profile: NlCoreRelatedPersonProfile, referenceID: String, relationship: MgoCodeableConcept?, resourceType: String, role: ExtensionValueOfMgoCodeableConcept?, telecom: [NlCoreRelatedPersonTelecom]?) {
        self.address = address
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.name = name
        self.patient = patient
        self.period = period
        self.profile = profile
        self.referenceID = referenceID
        self.relationship = relationship
        self.resourceType = resourceType
        self.role = role
        self.telecom = telecom
    }
}

// MARK: NlCoreRelatedPerson convenience initializers and mutators

public extension NlCoreRelatedPerson {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCoreRelatedPerson.self, from: data)
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
        address: [NlCoreRelatedPersonAddress]?? = nil,
        fhirVersion: NlCoreObservationFhirVersion? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        name: [NlCoreRelatedPersonName]?? = nil,
        patient: MgoReference?? = nil,
        period: MgoPeriod?? = nil,
        profile: NlCoreRelatedPersonProfile? = nil,
        referenceID: String? = nil,
        relationship: MgoCodeableConcept?? = nil,
        resourceType: String? = nil,
        role: ExtensionValueOfMgoCodeableConcept?? = nil,
        telecom: [NlCoreRelatedPersonTelecom]?? = nil
    ) -> NlCoreRelatedPerson {
        return NlCoreRelatedPerson(
            address: address ?? self.address,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            name: name ?? self.name,
            patient: patient ?? self.patient,
            period: period ?? self.period,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            relationship: relationship ?? self.relationship,
            resourceType: resourceType ?? self.resourceType,
            role: role ?? self.role,
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
